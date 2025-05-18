import 'package:bridgecare/features/administrador/home_admin.dart';
import 'package:flutter/material.dart';

class PuentesAdmin extends StatefulWidget {
  const PuentesAdmin({super.key});

  @override
  State<PuentesAdmin> createState() => _PuentesAdminState();
}

class _PuentesAdminState extends State<PuentesAdmin> {
  bool isFirstChecked = true;
  bool isSecondChecked = false;
  String filtro = '';

  List<Map<String, dynamic>> puentes = [
    {
      'nombre': 'Puente A',
      'municipio': 'Arbelaez',
      'tieneInventario': true,
      'tieneInspeccion': true,
    },
    {
      'nombre': 'Puente B',
      'municipio': 'San Bernardo',
      'tieneInventario': true,
      'tieneInspeccion': false,
    },
    {
      'nombre': 'Puente C',
      'municipio': 'Pasca',
      'tieneInventario': false,
      'tieneInspeccion': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final puentesFiltrados = puentes.where((puente) {
      if (isFirstChecked) {
        return puente['nombre'].toLowerCase().contains(filtro.toLowerCase());
      } else {
        return puente['municipio'].toLowerCase().contains(filtro.toLowerCase());
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
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
              // Header blanco con bordes
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xe6ffffff),
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
                              builder: (context) => const HomeAdmin()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Administrar Puentes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Filtros
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

              const SizedBox(height: 10),

              // Lista de puentes
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xccffffff),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: puentesFiltrados.length,
                      itemBuilder: (context, index) {
                        final puente = puentesFiltrados[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nombre: ${puente['nombre']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("Municipio: ${puente['municipio']}"),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: puente['tieneInventario']
                                          ? () {
                                              // editar inventario
                                            }
                                          : null,
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text("Inventario"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff01579a),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: puente['tieneInventario']
                                          ? () {
                                              // editar inspección
                                            }
                                          : null,
                                      icon:
                                          const Icon(Icons.edit_note, size: 18),
                                      label: const Text("Inspección"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: puente['tieneInventario']
                                          ? () {
                                              // eliminar inventario
                                            }
                                          : null,
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text("Eliminar Inv."),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: puente['tieneInspeccion']
                                          ? () {
                                              // eliminar inspección
                                            }
                                          : null,
                                      icon: const Icon(Icons.delete_forever,
                                          size: 18),
                                      label: const Text("Eliminar Insc."),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
