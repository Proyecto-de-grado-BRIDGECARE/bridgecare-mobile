import 'package:bridgecare/core/widgets/navbar.dart';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/form_inspection.dart';
import 'package:bridgecare/features/bridge_management/inventory/presentation/pages/form_inventario.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_inspection.dart';
import 'package:bridgecare/features/user_management/create_user/presentation/pages/create_user.dart';
import 'package:bridgecare/features/user_management/read_user/presentation/pages/read_user.dart';
import 'package:bridgecare/features/user_management/update_user/presentation/pages/update_user.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginPage(),
    '/inventarioForm': (context) => FormInventario(),
    '/inspeccionForm': (context) => FormInspection(),
    '/main': (context) => const BottomNavWrapper(),
    '/registro': (context) => RegistroUsuario(),
    '/modificarUsuario': (context) => ModificarUsuario(),
    '/usuarios': (context) => ListaUsuarios(),
    '/inspecciones': (context) => InspeccionesPage(),
  };
}
