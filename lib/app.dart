// ignore_for_file: unused_import

import 'package:bridgecare/config/app_routes.dart';
import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:bridgecare/shared/services/api_service.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_manager.dart';
import 'package:bridgecare/shared/widgets/splash_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => DatabaseService()),
        Provider(create: (_) => ApiService()),
        Provider(
          create: (context) => QueueManager(
            dbService: context.read<DatabaseService>(),
            apiService: context.read<ApiService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BridgeCare',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: context.watch<ThemeProvider>().themeMode,
        home: SplashToLoginTransition(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
