import 'package:flutter/material.dart';
import '../../../bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';

class BridgeListScreen extends StatefulWidget {
  BridgeListScreen({super.key});

  @override
  State<BridgeListScreen> createState() => _BridgeListState();
}

class _BridgeListState extends State<BridgeListScreen> {
  bool isSecondChecked = false;
  bool isFirstChecked = false;
  final List<Map<String, String>> puentes = [
    {'nombre': 'facha', 'fecha': '15/07/2016'},
    {'nombre': 'Tower', 'fecha': '15/07/2016'},
    {'nombre': 'Millau', 'fecha': '15/07/2016'},
    {'nombre': 'Ponte', 'fecha': '15/07/2016'},
    {'nombre': 'Charles', 'fecha': '15/07/2016'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF111D2C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Lista de puentes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Buscar...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.orange, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.orange, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.search, color: Colors.orange, size: 32),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isFirstChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                if (!isSecondChecked || !value!) {
                                  isFirstChecked = value!;
                                }
                              });
                            },
                          ),
                          Text("Puente", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isSecondChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                if (!isFirstChecked || !value!) {
                                  isSecondChecked = value!;
                                }
                              });
                            },
                          ),
                          Text("Municipio", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(
                              child: Text("Nombre",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              child: Text("Fecha Creación",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 100),
                        ],
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: puentes.length,
                          itemBuilder: (context, index) {
                            final puente = puentes[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(puente['nombre']!)),
                                  Expanded(child: Text(puente['fecha']!)),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => InspectionFormScreen(usuarioId: 1, puenteId: 1),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text("Nueva inspección",
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
