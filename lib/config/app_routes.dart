import 'package:bridgecare/features/administrador/presentation/user_auth.dart';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_bridge.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/search_inspection.dart';
import 'package:bridgecare/features/user_management/create_user/presentation/pages/create_user.dart';
import 'package:bridgecare/features/user_management/update_user/presentation/pages/update_user.dart';
import 'package:flutter/material.dart';

import '../features/administrador/presentation/list_puentes_admin.dart';
import '../features/administrador/presentation/list_user_admin.dart';
import '../features/bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import '../features/bridge_management/inventory/presentation/pages/inventario_form_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginPage(),
    '/home': (context) => const HomePage(usuarioId: 1, tipoUsuario: 1,),
    //'/registro': (context) => RegistroUsuario(),
    '/modificarUsuario': (context) => ModificarUsuario(),
    '/inspecciones': (context) => InspeccionesPage(),
    //'/autorizaciónUsuario': (context) => AutorizacionUsuario(),
    '/updateUser': (context) => ModificarUsuario(),
    '/createUser': (context) => RegistroUsuario(),
    '/SearchBridge': (context) => BridgeListScreen(),
    '/forminspeccion': (context) => InspectionFormScreen(puenteId: 3),
    '/forminventario': (context) => InventoryFormScreen(usuarioId:1),
    '/puenteslistAdmin': (context) => PuentesListAdminScreen(),
    '/usuarioslistAdmin': (context) => UsuariosListAdminScreen(),
    //Rutas administrador
    //'/Autorizacion' :(context) => AutorizacionUsuario(),
    '/det': (context) => DetallesUsuario(
          user: {},
        ), //no sirve aun
    //'/homeAdmin': (context) => const HomeAdmin(),
  };
}
