import 'dart:convert';

import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bridgecare/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http_parser/http_parser.dart' as parser;

const String uploadTask = "uploadInspectionTask";

// Initialize notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Ensure Flutter bindings are initialized and preserve the splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Request notification permission
  final permissionStatus = await requestNotificationPermission();
  debugPrint('Notification permission status: $permissionStatus');

  // Initialize Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Initialize flutter_local_notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'upload_queue_channel', // Channel ID
    'Upload Queue', // Channel name
    description: 'Shows status of inspection upload queue',
    importance: Importance.high,
    playSound: false,
    enableVibration: false,
    showBadge: false,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Run the app with theme provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );

  // Defer heavy initialization until after the first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Remove splash screen after initialization is complete
    FlutterNativeSplash.remove();
  });
}

// Function to request notification permission
Future<PermissionStatus> requestNotificationPermission() async {
  return await Permission.notification.request();
}

// Workmanager callback
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == uploadTask) {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString('inspection_queue');
      if (queueJson == null || queueJson.isEmpty) {
        await flutterLocalNotificationsPlugin.cancel(1);
        return true;
      }

      final List<dynamic> queue = jsonDecode(queueJson);
      if (queue.isEmpty) {
        await flutterLocalNotificationsPlugin.cancel(1);
        return true;
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'upload_queue_channel',
        'Upload Queue',
        channelDescription: 'Shows status of inspection upload queue',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false,
        showProgress: true,
        maxProgress: 100,
        progress: 0,
      );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );
      await flutterLocalNotificationsPlugin.show(
        1,
        'Upload Queue Active',
        'Processing ${queue.length} inspection(s) in the background',
        notificationDetails,
      );

      var connectivityResult = await (Connectivity().checkConnectivity());
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (!isConnected) {
        return false;
      }

      for (var item in List.from(queue)) {
        final inspeccion = item['inspeccion'];
        final imagePaths = item['imagePaths'] as List<dynamic>;
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.bridgecare.com.co/inspeccion/add'),
        );
        request.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
        request.files.add(http.MultipartFile.fromString(
          'inspeccion',
          jsonEncode(inspeccion),
          contentType: parser.MediaType('application', 'json'),
        ));
        for (var path in imagePaths) {
          request.files.add(await http.MultipartFile.fromPath('images', path));
        }

        debugPrint('Background Request Headers: ${request.headers}');
        debugPrint(
            'Background Request Files: ${request.files.map((f) => f.filename).toList()}');

        try {
          final response = await request.send();
          final responseBody = await response.stream.bytesToString();
          if (response.statusCode == 200 || response.statusCode == 201) {
            queue.remove(item);
            await prefs.setString('inspection_queue', jsonEncode(queue));
            await flutterLocalNotificationsPlugin.show(
              1,
              'Upload Queue Active',
              'Processing ${queue.length} inspection(s) in the background',
              notificationDetails,
            );
          } else {
            debugPrint('Upload failed: ${response.statusCode} - $responseBody');
            return false;
          }
        } catch (e) {
          debugPrint('Error uploading: $e');
          return false;
        }
      }
      if (queue.isEmpty) {
        await flutterLocalNotificationsPlugin.cancel(1);
      }
      return queue.isEmpty;
    }
    return true;
  });
}
