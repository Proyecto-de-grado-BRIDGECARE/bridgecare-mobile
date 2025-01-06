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
          GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              Image.asset('assets/images/puente-inicio.png'),
              Image.asset('assets/images/puente-inicio.png'),
              Image.asset('assets/images/puente-inicio.png'),
              Image.asset('assets/images/puente-inicio.png'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
                'Bienvenido a BridgeCare, la aplicación para el diagnostico del estado de un puente',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.black.withOpacity(1))),
          )
        ],
      ),
    );
  }
}
