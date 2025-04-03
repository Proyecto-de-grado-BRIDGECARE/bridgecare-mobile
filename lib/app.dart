// ignore_for_file: unused_import

import 'package:bridgecare/config/app_routes.dart';
import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/core/widgets/navbar.dart';
import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:bridgecare/shared/widgets/splash_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'JosefinSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'JosefinSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark, // 👈 Este valor es obligatorio
        ),
      ),

      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      initialRoute: '/SearchBridge',
      routes: AppRoutes.routes,
    );
  }
}
