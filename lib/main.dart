import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bridgecare/app.dart';

void main() async {
  // Ensure Flutter bindings are initialized and preserve the splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Request notification permission
  final permissionStatus = await requestNotificationPermission();
  debugPrint('Notification permission status: $permissionStatus');

  // Run the app immediately with theme provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );

  // Defer heavy initialization until after the first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Initialize database service
    final dbService = DatabaseService();
    final dbStart = DateTime.now();
    await dbService.database;
    debugPrint(
        'DB init: ${DateTime.now().difference(dbStart).inMilliseconds}ms');

    // Initialize queue service
    final queueService = QueueService();
    final queueStart = DateTime.now();
    await queueService.initialize();
    debugPrint(
        'Queue init: ${DateTime.now().difference(queueStart).inMilliseconds}ms');

    // Remove splash screen after initialization is complete
    FlutterNativeSplash.remove();
  });
}

// Function to request notification permission
Future<PermissionStatus> requestNotificationPermission() async {
  return await Permission.notification.request();
}
