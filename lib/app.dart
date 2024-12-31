import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeCare',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        //'/home': (context) => HomePage(),
      },
    );
  }
}