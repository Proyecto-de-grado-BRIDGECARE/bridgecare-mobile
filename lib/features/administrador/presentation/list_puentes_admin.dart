import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/features/search_bridge/services/bridge_service.dart';
import 'package:flutter/material.dart';

import '../../bridge_management/alert/presentation/pages/alert_page.dart';
import '../../bridge_management/inventory/presentation/pages/inventario_form_page.dart';
import '../../bridge_management/services/inventory_service.dart';

class PuentesListAdminScreen extends StatefulWidget {
  final int usuarioId;
  const PuentesListAdminScreen({required this.usuarioId, super.key});

  @override
  State<PuentesListAdminScreen> createState() => _PuentesListAdminState();
}

class _PuentesListAdminState extends State<PuentesListAdminScreen> {
  bool isFirstChecked = true;
  bool isSecondChecked = false;
  // final InventarioService _inventarioService =
  //     InventarioService(); //para eliminar inventario
  final BridgeService _puenteService = BridgeService(); //litar puentes
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
      debugPrint("Error al cargar puentes: $e");
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
              // Header blanco con bordes
              Container(
                decoration: BoxDecoration(
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
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      // <- Aquí el cambio importante
                      child: Text(
                        'Administrar Puentes',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Previene overflow visual
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
                                  _filtrar(value);
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
                                  color: Colors.white.withValues(alpha: 0.3),
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
                                _filtrar(value);
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
                                color: Colors.white.withValues(alpha: 0.3),
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
                      color: const Color(0xccffffff),
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
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nombre: ${puente.nombre}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                    "Municipio: ${puente.regional}"),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_horiz,
                                                color: Colors.blueAccent,
                                                size: 40),
                                            onSelected: (value) async {
                                              switch (value) {
                                                case 'alertas':
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AlertScreen(
                                                        puenteId: puente.id!,
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                                case 'editar':
                                                  try {
                                                    final inventario =
                                                        await InventarioService()
                                                            .getInventarioDTOporPuente(
                                                                puente.id!);
                                                    if (inventario != null &&
                                                        context.mounted) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              InventoryFormScreen(
                                                            usuarioId: widget
                                                                .usuarioId,
                                                            inventario:
                                                                inventario,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Este puente no tiene inventario.')),
                                                        );
                                                      }
                                                    }
                                                  } catch (e) {
                                                    debugPrint(
                                                        "Error al obtener inventario: $e");
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Error al cargar el inventario')),
                                                      );
                                                    }
                                                  }
                                                  break;

                                                case 'eliminar':
                                                  final confirm =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Confirmar eliminación'),
                                                      content: Text(
                                                          '¿Eliminar el puente "${puente.nombre}"?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: const Text(
                                                              'Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          child: const Text(
                                                              'Eliminar',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    try {
                                                      await _puenteService
                                                          .deletePuente(
                                                              puente.id!);
                                                      _cargarPuentes();
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Puente eliminado exitosamente')),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      debugPrint(
                                                          'Error al eliminar puente: $e');
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              e
                                                                      .toString()
                                                                      .contains(
                                                                          '403')
                                                                  ? 'No tienes permiso para eliminar este puente.'
                                                                  : 'Ocurrió un error al eliminar el puente.',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                  break;
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'alertas',
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.orange),
                                                    SizedBox(width: 8),
                                                    Text("Ver alertas"),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'eliminar',
                                                child: Row(
                                                  children: const [
                                                    Icon(Icons.close,
                                                        color:
                                                            Colors.redAccent),
                                                    SizedBox(width: 8),
                                                    Text("Eliminar"),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'editar',
                                                child: Row(
                                                  children: const [
                                                    Icon(Icons.edit,
                                                        color:
                                                            Colors.blueAccent),
                                                    SizedBox(width: 8),
                                                    Text("Editar"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // más controlado y elegante
                                      Align(
                                        alignment: Alignment
                                            .centerLeft, // puedes cambiar a center si prefieres
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InspectionFormScreen(
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
                                      ),
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
