import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/core/widgets/navbar.dart';
import 'package:bridgecare/features/formularioInspeccion/form_inspection.dart';
import 'package:bridgecare/features/listaPuente/lista_puente.dart';
import 'package:bridgecare/shared/forms/form_inventory.dart';
import 'package:bridgecare/shared/forms/form_inspection.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/inventarioForm': (context) => FormInventory(),
        '/inspeccionForm': (context) => FormInspection(),
        '/main': (context) => const BottomNavWrapper(),
      },
    );
  }
}
