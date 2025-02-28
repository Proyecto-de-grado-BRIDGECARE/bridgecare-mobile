import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:bridgecare/features/registroUsuario/registroUsuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      initialRoute: '/registro',
      routes: {
        // '/login': (context) => LoginPage(),
        //'/home': (context) => HomePage(),
        '/registro': (context) => registroUsuario(),
      },
    );
  }
}
