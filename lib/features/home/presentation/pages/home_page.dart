import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/bridgecare_logo.png',
            fit: BoxFit.contain, height: 100),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F0147),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          Expanded(
              child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              Image.asset('assets/images/puente-inicio.png'),
              Image.asset('assets/images/puente-inicio.png'),
              Image.asset('assets/images/puente-inicio.png'),
              Image.asset('assets/images/puente-inicio.png'),
            ],
          ))
        ],
      ),
    );
  }
}
