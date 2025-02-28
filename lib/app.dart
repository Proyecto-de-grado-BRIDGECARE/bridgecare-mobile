import 'package:bridgecare/features/formularioInspeccion/form_inspection.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      initialRoute: '/inspeccionForm',
      routes: {
        //'/login': (context) => LoginPage(),
        //'/inventarioForm': (context) => FormInventory(),
        '/inspeccionForm': (context) => FormInspection(),
        //'/home': (context) => HomePage(),
      },
    );
  }
}
