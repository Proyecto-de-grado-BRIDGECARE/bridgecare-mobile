import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/core/widgets/navbar.dart';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/formularioInspeccion/form_inspection.dart';
import 'package:bridgecare/features/formularioInventario/form_Inventario.dart';

import 'package:bridgecare/features/registroUsuario/registroUsuario.dart';
import 'package:bridgecare/features/modificarUsuarios/modificarUsuarios.dart';
import 'package:bridgecare/features/listaUsuarios/listaUsuarios.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';
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
        '/inventarioForm': (context) => formInventario(),
        '/inspeccionForm': (context) => FormInspection(),
        '/main': (context) => const BottomNavWrapper(),
        '/registro': (context) => registroUsuario(),
        '/modificarUsuario': (context) => modificarUsuario(),
        '/usuarios': (context) => listaUsuarios(),
      },
    );
  }
}
