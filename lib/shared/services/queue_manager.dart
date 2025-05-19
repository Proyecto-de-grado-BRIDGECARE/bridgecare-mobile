import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/api_service.dart';

class QueueManager {
  final DatabaseService _dbService;
  final ApiService _apiService;

  QueueManager(
      {required DatabaseService dbService, required ApiService apiService})
      : _dbService = dbService,
        _apiService = apiService;

  Future<void> queueImage(
    XFile image,
    int bridgeId,
    String inspectionId,
    String componentKey,
  ) async {
    final bytes = await image.readAsBytes();
    final imageId = DateTime.now().millisecondsSinceEpoch.toString();
    const chunkSize = 1024 * 1024; // 1MB
    final chunks = <List<int>>[];
    for (int i = 0; i < bytes.length; i += chunkSize) {
      chunks.add(bytes.sublist(
        i,
        i + chunkSize < bytes.length ? i + chunkSize : bytes.length,
      ));
    }

    bool initiated = false;
    try {
      await _apiService.initiateImageUpload(
        imageId,
        chunks.length,
        image.name,
        bridgeId,
        inspectionId, // Allow UUID
      );
      initiated = true;
    } catch (e) {
      print('Initiate failed for $imageId: $e');
    }

    for (int i = 0; i < chunks.length; i++) {
      await _dbService.insertImageChunk({
        'image_id': imageId,
        'chunk_index': i,
        'data': base64Encode(chunks[i]),
        'retry_count': 0,
        'timestamp': DateTime.now().toIso8601String(),
        'initiated': initiated ? 1 : 0,
        'filename': image.name,
        'bridge_id': bridgeId,
        'inspection_id': inspectionId,
        'component_key': componentKey,
      });
    }
  }

  Future<void> processQueue() async {
    await _processImageQueue();
    await _processJsonQueue();
  }

  Future<void> queueInspectionJson(
    Map<String, dynamic> json,
    int bridgeId,
    String? inspectionId,
  ) async {
    final tempInspectionId = inspectionId?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    await _dbService.insertInspectionJson({
      'inspection_id': tempInspectionId,
      'bridge_id': bridgeId,
      'data': jsonEncode(json),
      'retry_count': 0,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _processImageQueue() async {
    final images = await _dbService.getQueuedImages();
    for (var image in images) {
      final imageId = image['image_id'] as String;
      final filename = image['filename'] as String;
      final bridgeId = image['bridge_id'] as int;
      final inspectionId = image['inspection_id'] as String;
      final componentKey = image['component_key'] as String;

      final chunks = await _dbService.getImageChunks(imageId);
      bool initiated = chunks.any((chunk) => chunk['initiated'] == 1);
      if (!initiated) {
        try {
          await _apiService.initiateImageUpload(
            imageId,
            chunks.length,
            filename,
            bridgeId,
            inspectionId,
          );
          await _dbService.updateImageChunks(
            imageId,
            {'initiated': 1, 'retry_count': 0},
          );
          initiated = true;
        } catch (e) {
          print('Re-initiate failed for $imageId: $e');
          continue;
        }
      }

      bool allChunksUploaded = true;
      for (var chunk in chunks) {
        int retryCount = chunk['retry_count'] as int;
        if (retryCount >= 3) {
          allChunksUploaded = false;
          continue;
        }

        try {
          final data = base64Decode(chunk['data'] as String);
          final response = await _apiService.uploadImageChunk(
            imageId,
            chunk['chunk_index'] as int,
            data,
            bridgeId,
            inspectionId,
          );
          if (response.statusCode == 200) {
            await _dbService.deleteImageChunk(chunk['id'] as int);
          } else {
            await _dbService.updateImageChunk(
              chunk['id'] as int,
              {'retry_count': retryCount + 1},
            );
            allChunksUploaded = false;
          }
        } catch (e) {
          print('Chunk error for $imageId, chunk ${chunk['chunk_index']}: $e');
          await _dbService.updateImageChunk(
            chunk['id'] as int,
            {'retry_count': retryCount + 1},
          );
          allChunksUploaded = false;
        }
      }

      if (allChunksUploaded) {
        try {
          final url = await _apiService.completeImageUpload(
            imageId,
            filename,
            bridgeId,
            inspectionId,
          );
          await _dbService.storeImageUrl(
            inspectionId, // Keep as String
            componentKey,
            url,
          );
        } catch (e) {
          print('Complete error for $imageId: $e');
        }
      }
    }
  }

  Future<void> _processJsonQueue() async {
    final inspections = await _dbService.getQueuedInspections();
    for (var inspection in inspections) {
      final inspectionId = inspection['inspection_id'] as String;
      final bridgeId = inspection['bridge_id'] as int;
      final jsonData = jsonDecode(inspection['data'] as String);
      int retryCount = inspection['retry_count'] as int;

      if (retryCount >= 3) continue;

      try {
        final response = await _apiService.uploadInspectionJson(
          jsonData,
          bridgeId,
          inspectionId,
        );
        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          final message = responseBody['message'] as String;
          final idMatch = RegExp(r'ID: (\d+)').firstMatch(message);
          final newInspectionId = idMatch?.group(1);
          if (newInspectionId != null) {
            await _dbService.deleteInspectionJson(inspection['id'] as int);
            await _dbService.updateInspectionId(inspectionId, newInspectionId);
          } else {
            throw Exception('Failed to parse new inspectionId');
          }
        } else {
          await _dbService.updateInspectionJson(
            inspection['id'] as int,
            {'retry_count': retryCount + 1},
          );
        }
      } catch (e) {
        debugPrint('JSON upload error for $inspectionId: $e');
        await _dbService.updateInspectionJson(
          inspection['id'] as int,
          {'retry_count': retryCount + 1},
        );
      }
    }
  }

  Future<Map<String, int>> getQueueStatus() async {
    final imageCount = await _dbService.getImageQueueCount();
    final jsonCount = await _dbService.getJsonQueueCount();
    return {'images': imageCount, 'inspections': jsonCount};
  }
}
