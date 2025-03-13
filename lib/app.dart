import 'package:bridgecare/config/app_routes.dart';
import 'package:bridgecare/core/providers/theme_provider.dart';
import 'package:bridgecare/core/widgets/navbar.dart';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/user_auth/user_auth.dart';
import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/form_inspection.dart';
import 'package:bridgecare/features/bridge_management/inventory/presentation/pages/form_inventario.dart';
import 'package:bridgecare/features/user_management/create_user/presentation/pages/create_user.dart';
import 'package:bridgecare/features/user_management/update_user/presentation/pages/update_user.dart';
import 'package:bridgecare/features/user_management/read_user/presentation/pages/read_user.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_inspection.dart';
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
      initialRoute: '/autorizaciónUsuario',
      routes: {
        '/login': (context) => const LoginPage(),
        '/inventarioForm': (context) => FormInventario(),
        '/inspeccionForm': (context) => FormInspection(),
        '/main': (context) => const BottomNavWrapper(),
        '/registro': (context) => RegistroUsuario(),
        '/modificarUsuario': (context) => ModificarUsuario(),
        '/usuarios': (context) => ListaUsuarios(),
        '/inspecciones': (context) => InspeccionesPage(),
        '/autorizaciónUsuario': (context) => autorizacionUsuario(),
      },
    );
  }
}
