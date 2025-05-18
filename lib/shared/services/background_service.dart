import 'dart:async';
import 'package:bridgecare/shared/services/api_service.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:bridgecare/shared/services/queue_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

@pragma('vm:entry-point')
class BackgroundService {
  static Future<void> initialize() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FlutterNotificationChannel().registerNotificationChannel(
        id: 'upload_service',
        name: 'BridgeCare Upload Service',
        description: 'Notifications for background uploads',
        importance: NotificationImportance.IMPORTANCE_DEFAULT,
      );
    }

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
        notificationChannelId: 'upload_service',
        initialNotificationTitle: 'BridgeCare Upload Service',
        initialNotificationContent: 'Uploading items',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    final queueManager = QueueManager(
      dbService: DatabaseService(),
      apiService: ApiService(),
    );
    bool isForeground = false;
    AppLifecycleState appState = AppLifecycleState.paused;

    service.on('updateAppState').listen((event) {
      if (event != null && event['state'] != null) {
        appState = AppLifecycleState.values.firstWhere(
          (state) => state.toString() == event['state'],
          orElse: () => AppLifecycleState.paused,
        );
        debugPrint('Background: App state updated to $appState');
      }
    });

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final status = await queueManager.getQueueStatus();
        final imageCount = status['images'] ?? 0;
        final jsonCount = status['inspections'] ?? 0;
        final totalCount = imageCount + jsonCount;

        if (service is AndroidServiceInstance) {
          if (totalCount == 0 || appState == AppLifecycleState.resumed) {
            if (isForeground) {
              debugPrint(
                  'Background: No items or app resumed, switching to background mode');
              service.setAsBackgroundService();
              isForeground = false;
            }
            if (totalCount == 0) return;
          } else if (!isForeground && totalCount > 0) {
            debugPrint(
                'Background: Items queued and app paused, switching to foreground mode');
            service.setAsForegroundService();
            service.setForegroundNotificationInfo(
              title: 'BridgeCare Upload Service',
              content:
                  'Uploading $imageCount image${imageCount != 1 ? 's' : ''}, $jsonCount inspection${jsonCount != 1 ? 's' : ''}',
            );
            isForeground = true;
          }
        }

        debugPrint(
            'Background retry triggered, $imageCount images, $jsonCount inspections');
        await queueManager.processQueue();
      } catch (e) {
        debugPrint('Background service error: $e');
        if (service is AndroidServiceInstance) {
          service.setAsBackgroundService();
          isForeground = false;
        }
      }
    });
  }
}
