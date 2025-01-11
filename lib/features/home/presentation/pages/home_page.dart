import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> imagenes = [
    'assets/images/puente-inicio.jpeg',
    'assets/images/puente-inicio.jpeg',
    'assets/images/puente-inicio.jpeg',
    'assets/images/puente-inicio.jpeg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/bridgecare_logo.png',
              fit: BoxFit.contain, height: 150),
          centerTitle: true,
          backgroundColor: const Color(0xFF0F0147),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          toolbarHeight: 150,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              children: imagenes.map((path) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset(path, fit: BoxFit.cover),
                    ));
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Bienvenido a BridgeCare, la aplicación para el diagnostico del estado de un puente',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 17),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home,
                      color: Color(0xFFC5C5C5), size: 40),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.search,
                      color: Color(0xFFC5C5C5), size: 40),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon:
                      const Icon(Icons.add, color: Color(0xFFF29E23), size: 50),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications,
                      color: Color(0xFFC5C5C5), size: 40),
                  label: 'home'),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person,
                      color: Color(0xFFC5C5C5), size: 40),
                  label: 'home')
            ]));
  }
}

// GridView.count(
//               padding: const EdgeInsets.all(20),
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               shrinkWrap: true,
//               children: imagenes.map((path) {
//                 return ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.asset(path, fit: BoxFit.cover));
//               }).toList(),
//             ),
