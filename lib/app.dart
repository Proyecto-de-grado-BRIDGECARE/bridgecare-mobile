import 'package:bridgecare/config/app_routes.dart';
import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/shared/widgets/splash_transition.dart';
import 'package:bridgecare/features/bridge_management/inventory/presentation/pages/form_inventario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode:
      Provider.of<ThemeProvider>(context).themeMode, // Use theme provider
      home: FormInventario(),//const SplashToLoginTransition(),
      routes: AppRoutes.routes,
    );
  }
}