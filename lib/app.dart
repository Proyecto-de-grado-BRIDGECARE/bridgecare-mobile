import 'package:bridgecare/features/formularioInventario/form_Inventario.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      initialRoute: '/inventarioForm',
      routes: {
        //'/login': (context) => LoginPage(),
        '/inventarioForm': (context) => formInventario(),
        //'/home': (context) => HomePage(),
      },
    );
  }
}
