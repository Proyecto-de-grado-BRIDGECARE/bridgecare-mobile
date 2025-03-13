import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:bridgecare/app.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  initializeApp().then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Remove splash screen after everything is ready
    FlutterNativeSplash.remove();
  });
}

Future<void> initializeApp() async {
  // Add any setup tasks (e.g., database, API calls, preferences)
  await Future.delayed(Duration(milliseconds: 500)); // Simulate loading
}
