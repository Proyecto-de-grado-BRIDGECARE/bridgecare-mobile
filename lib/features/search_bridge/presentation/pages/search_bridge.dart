import 'package:flutter/material.dart';
import '../../../bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:bridgecare/features/home/presentation/pages/home_page.dart';
import 'package:bridgecare/features/search_bridge/presentation/pages/services/bridge_service.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';

class BridgeListScreen extends StatefulWidget {
  BridgeListScreen({super.key});

  @override
  State<BridgeListScreen> createState() => _BridgeListState();
}

class _BridgeListState extends State<BridgeListScreen> {
  bool isSecondChecked = false;
  bool isFirstChecked = false;
  final BridgeService _puenteService = BridgeService();
  List<Puente> _puentes = [];
  List<Puente> _puentesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarPuentes();
  }

  Future<void> _cargarPuentes() async {
    try {
      final data = await _puenteService.getAllPuentes();
      setState(() {
        _puentes = data;
        _puentesFiltrados = data;
      });
    } catch (e) {
      print("Error al cargar puentes: $e");
    }
  }

  void _filtrar(String texto) {
    final query = texto.toLowerCase();

    setState(() {
      if (isFirstChecked) {
        _puentesFiltrados = _puentes
            .where((puente) => puente.nombre.toLowerCase().contains(query))
            .toList();
      } else if (isSecondChecked) {
        _puentesFiltrados = _puentes
            .where((puente) => puente.regional.toLowerCase().contains(query))
            .toList();
      } else {
        _puentesFiltrados = _puentes;
      }
    });
  }

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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (Route<dynamic> route) => false,
                        );
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
                                  print("Filtrar por puente: $value");
                                  _filtrar(value);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                print("Buscar puente");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
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
                                print("Filtrar por municipio: $value");
                                _filtrar(value);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              print("Buscar municipio");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
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
                            itemCount: _puentesFiltrados.length,
                            itemBuilder: (context, index) {
                              final puente = _puentesFiltrados[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
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
                                      Text("Nombre: ${puente.nombre}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text("Municipio: ${puente.regional}"),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InspectionFormScreen(
                                                  usuarioId:
                                                      1, // Reemplazar con el real si lo tienes
                                                  puenteId: puente.id!,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.add,
                                              size: 20,
                                              color: Color(0xff281537)),
                                          label: const Text("Inspección"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff01579a),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(70),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            textStyle:
                                                const TextStyle(fontSize: 14),
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
