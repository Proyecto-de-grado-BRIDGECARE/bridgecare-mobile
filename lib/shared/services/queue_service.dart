import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bridgecare/config/constants.dart';
import 'package:bridgecare/shared/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'database_service.dart';
import 'dart:async';

@pragma('vm:entry-point')
class QueueService with ChangeNotifier {
  static final QueueService _instance = QueueService._internal();
  factory QueueService() => _instance;
  QueueService._internal();

  final DatabaseService _dbService = DatabaseService();
  bool _hasFailedTasks = false;
  double _queueProgress = 0.0;

  bool get hasFailedTasks => _hasFailedTasks;
  double get queueProgress => _queueProgress;

  Future<void> initialize() async {
    final result =
        await FlutterNotificationChannel().registerNotificationChannel(
      description: 'Queue sync notifications',
      id: 'form_app_queue',
      name: 'Form App Queue',
      importance: NotificationImportance.IMPORTANCE_DEFAULT,
    );
    await Utils.logToFile('Notification channel creation: $result');

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'form_app_queue',
        initialNotificationTitle: 'Form App Sync',
        initialNotificationContent: 'Syncing images and forms...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );
    await service.startService();
    await _updateQueueProgress();
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    final queueService = QueueService();
    final connectivity = Connectivity();
    int retryDelay = 5;

    service.on('stopService').listen((_) {
      service.stopSelf();
    });

    while (true) {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await Utils.logToFile('Connectivity detected, processing queue');
        await queueService.processQueue();
        retryDelay = 5;
      } else {
        retryDelay = (retryDelay * 2).clamp(5, 60);
        await Utils.logToFile(
          'No connectivity, retrying in $retryDelay seconds',
        );
      }
      await Future.delayed(Duration(seconds: retryDelay));
    }
  }

  Future<void> processQueue() async {
    try {
      bool madeProgress = true;
      while (madeProgress) {
        madeProgress = false;
        final tasks = await _dbService.getPendingTasks();
        final failedTasks = await _dbService.getFailedTasks();
        _hasFailedTasks = failedTasks.isNotEmpty;
        await _updateQueueProgress();
        await Utils.logToFile(
          'Processing queue: ${tasks.length} pending, ${failedTasks.length} failed',
        );

        // Convert tasks to mutable list and sort
        final mutableTasks = tasks.toList();
        mutableTasks.sort((a, b) {
          final taskTypeA = a['task_type'] as String;
          final taskTypeB = b['task_type'] as String;
          final dataA = jsonDecode(a['data'] as String) as Map<String, dynamic>;
          final dataB = jsonDecode(b['data'] as String) as Map<String, dynamic>;
          final imageUuidA = dataA['image_uuid'] ?? '';
          final imageUuidB = dataB['image_uuid'] ?? '';
          if (taskTypeA == taskTypeB) {
            return imageUuidA.compareTo(imageUuidB);
          }
          return taskTypeA == 'image_chunk' ? -1 : 1;
        });

        for (final task in mutableTasks) {
          final taskId = task['id'] as int;
          final taskType = task['task_type'] as String;
          final data = jsonDecode(task['data']) as Map<String, dynamic>;
          final retryCount = task['retry_count'] as int;
          final dependsOn = task['depends_on'] as String?;

          if (retryCount >= 5) {
            await _dbService.updateTaskStatus(taskId, 'failed');
            _hasFailedTasks = true;
            notifyListeners();
            await Utils.logToFile('Task $taskId failed: max retries reached');
            continue;
          }

          if (!await _canProcessTask(dependsOn)) {
            await Utils.logToFile('Task $taskId skipped: dependencies not met');
            continue;
          }

          int cycleRetries = 0;
          bool taskProcessed = false;

          while (cycleRetries < 3 && !taskProcessed) {
            await Utils.logToFile(
              'Attempting task $taskId ($taskType), retry $cycleRetries',
            );
            try {
              if (taskType == 'image_chunk') {
                taskProcessed = await _processImageChunkTask(
                  taskId,
                  data,
                  retryCount + cycleRetries,
                );
              } else if (taskType == 'form_submit') {
                taskProcessed = await _processFormSubmitTask(
                  taskId,
                  data,
                  retryCount + cycleRetries,
                );
              }
              if (taskProcessed) {
                madeProgress = true; // Mark progress to retry skipped tasks
              }
            } catch (e) {
              await Utils.logToFile('Error processing task $taskId: $e');
            }
            cycleRetries++;
            if (!taskProcessed) {
              await Future.delayed(Duration(milliseconds: 500));
            }
          }

          if (!taskProcessed) {
            await _dbService.incrementRetryCount(taskId);
            await _dbService.updateTaskStatus(
              taskId,
              retryCount + cycleRetries >= 5 ? 'failed' : 'pending',
            );
            notifyListeners();
            await Utils.logToFile(
              'Task $taskId not processed, status: ${retryCount + cycleRetries >= 5 ? 'failed' : 'pending'}',
            );
          }

          await _updateQueueProgress();
          await _cleanupCompletedImages();
        }
      }

      // Final check for completion
      final remainingTasks = await _dbService.getPendingTasks();
      final remainingFailedTasks = await _dbService.getFailedTasks();
      _hasFailedTasks = remainingFailedTasks.isNotEmpty;
      if (remainingTasks.isEmpty && !_hasFailedTasks) {
        _queueProgress = 1.0;
        notifyListeners();
        await Utils.logToFile(
          'Queue processing complete: no pending or failed tasks',
        );
      }
    } catch (e) {
      await Utils.logToFile('Error in processQueue: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFailedTasks() async {
    return await _dbService.getFailedTasks();
  }

  Future<bool> _canProcessTask(String? dependsOn) async {
    if (dependsOn == null || dependsOn.isEmpty) return true;
    final imageUuids = dependsOn.split(',');
    final images = await _dbService.database.then(
      (db) => db.query(
        'images',
        where: 'image_uuid IN (${imageUuids.map((_) => '?').join(',')})',
        whereArgs: imageUuids,
      ),
    );
    final result = images.every(
      (image) => image['upload_status'] == 'completed',
    );
    await Utils.logToFile(
      'Can process task with dependsOn=$dependsOn: $result',
    );
    return result;
  }

  Future<bool> _processImageChunkTask(
    int taskId,
    Map<String, dynamic> data,
    int retryCount,
  ) async {
    final imageUuid = data['image_uuid'] as String;
    final chunkIndex = data['chunk_index'] as int;
    final totalChunks = data['total_chunks'] as int;
    final localPath = data['local_path'] as String;
    final puenteId = data['puente_uuid'] as String;
    final inspeccionUuid = data['inspeccion_uuid'] as String;
    final componenteUuid = data['componente_uuid'] as String;

    final file = File(localPath);
    if (!await file.exists()) {
      await Utils.logToFile(
        'Image file not found: $localPath for task $taskId',
      );
      await _dbService.updateTaskStatus(taskId, 'failed');
      await _dbService.incrementRetryCount(taskId);
      return false;
    }

    final fileSize = await file.length();
    final chunkSize = Constants.chunkSize;
    final start = chunkIndex * chunkSize;
    final end = (start + chunkSize < fileSize) ? start + chunkSize : fileSize;
    final chunk = await file.readAsBytes().then(
          (bytes) => bytes.sublist(start, end),
        );

    final url =
        '${Constants.imageServiceUrl}/upload/$puenteId/$inspeccionUuid/$componenteUuid/$imageUuid?chunk=$chunkIndex&total=$totalChunks';

    try {
      await _dbService.updateTaskStatus(taskId, 'processing');
      final response = await http.post(
        Uri.parse(url),
        body: chunk,
        headers: {'Content-Type': 'application/octet-stream'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final db = await _dbService.database;
        await db.rawUpdate(
          'UPDATE images SET chunks_uploaded = chunks_uploaded + 1 WHERE image_uuid = ?',
          [imageUuid],
        );
        final image = await db.query('images',
            where: 'image_uuid = ?',
            whereArgs: [imageUuid]).then((maps) => maps.first);
        await Utils.logToFile(
          'Chunk $chunkIndex/$totalChunks for image $imageUuid, chunks_uploaded: ${image['chunks_uploaded']}/${image['chunk_count']}',
        );
        if (image['chunks_uploaded'] == image['chunk_count']) {
          await db.update(
            'images',
            {'upload_status': 'completed'},
            where: 'image_uuid = ?',
            whereArgs: [imageUuid],
          );
          await Utils.logToFile('Image $imageUuid upload completed');
        }
        await _dbService.updateTaskStatus(taskId, 'completed');
        await Utils.logToFile(
          'Uploaded chunk $chunkIndex/$totalChunks for image $imageUuid',
        );
        return true;
      } else if (response.statusCode == 503 || response.statusCode == 500) {
        await Utils.logToFile(
          'Server error (${response.statusCode}) for chunk $chunkIndex of image $imageUuid',
        );
        return false;
      } else {
        throw HttpException('Chunk upload failed: ${response.statusCode}');
      }
    } catch (e) {
      await Utils.logToFile(
        'Chunk $chunkIndex upload failed for image $imageUuid: $e',
      );
      return false;
    }
  }

  Future<bool> _processFormSubmitTask(
    int taskId,
    Map<String, dynamic> data,
    int retryCount,
  ) async {
    final inspeccionUuid = data['inspeccion_uuid'] as String;

    final forms = await _dbService.database.then(
      (db) => db.query('forms',
          where: 'inspeccion_uuid = ?', whereArgs: [inspeccionUuid]),
    );
    if (forms.isEmpty) {
      await Utils.logToFile('Form not found: $inspeccionUuid');
      await _dbService.updateTaskStatus(taskId, 'failed');
      await _dbService.incrementRetryCount(taskId);
      return false;
    }

    final form = forms.first;
    final payload = form['payload'] as String;

    try {
      await _dbService.updateTaskStatus(taskId, 'processing');
      final response = await http
          .post(
            Uri.parse('${Constants.inspectionServiceUrl}/submit'),
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        await _dbService.updateFormStatus(inspeccionUuid, 'submitted');
        await _dbService.updateTaskStatus(taskId, 'completed');
        await Utils.logToFile('Submitted form $inspeccionUuid');
        return true;
      } else if (response.statusCode == 503 || response.statusCode == 500) {
        await Utils.logToFile(
          'Server error (${response.statusCode}) for form $inspeccionUuid',
        );
        return false;
      } else {
        throw HttpException('Form submission failed: ${response.statusCode}');
      }
    } catch (e) {
      await Utils.logToFile('Form submission failed for $inspeccionUuid: $e');
      return false;
    }
  }

  Future<void> _cleanupCompletedImages() async {
    final completedImages = await _dbService.database.then(
      (db) => db.query(
        'images',
        where: 'upload_status = ?',
        whereArgs: ['completed'],
      ),
    );
    for (final image in completedImages) {
      final imageUuid = image['image_uuid'] as String;
      final chunkTasks = await _dbService.database.then(
        (db) => db.query(
          'queue',
          where: 'task_type = ? AND data LIKE ?',
          whereArgs: ['image_chunk', '%$imageUuid%'],
        ),
      );
      final allCompleted = chunkTasks.every(
        (task) => task['status'] == 'completed',
      );
      if (allCompleted) {
        final localPath = image['local_path'] as String;
        final file = File(localPath);
        try {
          if (await file.exists()) {
            await Future.delayed(Duration(seconds: 3)); // Increased delay
            if (await file.exists()) {
              await file.delete();
              await Utils.logToFile(
                'Deleted temporary file: $localPath for image $imageUuid',
              );
            }
          }
        } catch (e) {
          await Utils.logToFile(
            'Failed to delete temporary file $localPath for image $imageUuid: $e',
          );
        }
      } else {
        await Utils.logToFile(
          'Skipped cleanup for image $imageUuid: not all chunks completed',
        );
      }
    }
  }

  Future<void> retryFailedTasks() async {
    final failedTasks = await _dbService.getFailedTasks();
    final db = await _dbService.database;
    for (final task in failedTasks) {
      await db.update(
        'queue',
        {'status': 'pending', 'retry_count': 0},
        where: 'id = ?',
        whereArgs: [task['id']],
      );
    }
    _hasFailedTasks = false;
    notifyListeners();
    await Utils.logToFile('Retrying ${failedTasks.length} failed tasks');
    await processQueue();
  }

  Future<void> _updateQueueProgress() async {
    final allTasks = await _dbService.database.then((db) => db.query('queue'));
    final completedTasks =
        allTasks.where((task) => task['status'] == 'completed').toList();
    final totalTasks = allTasks.length;
    _queueProgress = totalTasks > 0 ? completedTasks.length / totalTasks : 1.0;
    notifyListeners();
    await Utils.logToFile(
      'Queue progress: ${(_queueProgress * 100).toStringAsFixed(1)}%',
    );
  }

  void logTaskCompleted(String message) {
    log('SUCCESS: $message', name: 'FormApp');
    Utils.logToFile('SUCCESS: $message');
  }

  void logTaskFailed(String message) {
    Utils.logError(message);
  }
}
