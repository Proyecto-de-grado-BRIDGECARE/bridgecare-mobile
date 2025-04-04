import 'package:flutter/material.dart';
import '../../../bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';

class BridgeListScreen extends StatefulWidget {
  const BridgeListScreen({super.key});

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
  final List<String> municipios = [
    'San Bernardo',
    'Faca',
    'Arbelaez',
    'Venecia',
    'Pasca'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff281537),
              Color(0xff1780cc),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header azul con título
              Container(
                decoration: BoxDecoration(
                  color: Color(0xccffffff),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(
                            context); // Go back to the previous screen
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Lista de puentes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Barra de búsqueda fuera del header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtros
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isFirstChecked,
                              side: const BorderSide(
                                  color: Colors.white,
                                  width: 2), // Color del borde
                              onChanged: (bool? value) {
                                setState(() {
                                  if (!isSecondChecked || !value!) {
                                    isFirstChecked = value!;
                                    isSecondChecked = false;
                                  }
                                });
                              },
                            ),
                            Text("Puente",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isSecondChecked,
                              side: const BorderSide(
                                  color: Colors.white,
                                  width: 2), // Color del borde
                              onChanged: (bool? value) {
                                setState(() {
                                  if (!isFirstChecked || !value!) {
                                    isSecondChecked = value!;
                                    isFirstChecked = false;
                                  }
                                });
                              },
                            ),
                            Text("Municipio",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),

                    // Campo
                    SizedBox(height: 8),

                    if (isFirstChecked)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xccffffff),
                                  hintText: 'Escribe el nombre del puente',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  debugPrint("Filtrar por puente: $value");
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                debugPrint("Buscar puente");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.3),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.search,
                                    color: Colors.white, size: 28),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (isSecondChecked)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xccffffff),
                                hintText: 'Escribe el nombre del municipio',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                debugPrint("Filtrar por municipio: $value");
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              debugPrint("Buscar municipio");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 255, 255, 0.3),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.search,
                                  color: Colors.white, size: 28),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Lista de puentes
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xccffffff),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: puentes.length,
                            itemBuilder: (context, index) {
                              final puente = puentes[index];

                              // Simulación de municipio (puedes reemplazar esto con tu dato real)
                              final municipio = municipios[index];

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Nombre: ${puente['nombre']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text("Municipio: $municipio"),
                                      SizedBox(height: 4),
                                      Text(
                                          "Fecha de creación: ${puente['fecha']}"),
                                      SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InspectionFormScreen(
                                                  puenteId: 1,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 20,
                                            color: Color(0xff281537),
                                          ),
                                          label: Text("Inspección"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff01579a),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(70),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            textStyle: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
      ),
    );
  }
}
