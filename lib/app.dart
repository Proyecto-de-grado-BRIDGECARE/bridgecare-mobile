import 'package:bridgecare/features/formularioInspeccion/form_inspection.dart';
import 'package:bridgecare/features/listaPuente/lista_puente.dart';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      initialRoute: '/listaPuentes',
      routes: {
        //'/login': (context) => LoginPage(),
        //'/inventarioForm': (context) => FormInventory(),
        //'/inspeccionForm': (context) => FormInspection(),
        '/listaPuentes': (context) => BridgeListScreen(),
        //'/home': (context) => HomePage(),
      },
    );
  }
}
