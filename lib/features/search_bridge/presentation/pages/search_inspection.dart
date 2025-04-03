import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bridgecare/features/user_management/models/inspection.dart';

class InspeccionesPage extends StatefulWidget {
  const InspeccionesPage({super.key});

  @override
  State<InspeccionesPage> createState() => _InspectionState();
}

class _InspectionState extends State<InspeccionesPage> {
  List<Inspeccion> _inspecciones = [];
  List<Map<String, dynamic>> _datos = [];
  List<Map<String, dynamic>> _datosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarJson();
  }

  Future<void> _cargarJson() async {
    final String jsonData = await rootBundle.loadString(
      'assets/inspecciones.json',
    );
    final List<dynamic> data = await json.decode(jsonData);

    setState(() {
      _inspecciones = data.map((item) => Inspeccion.fromJson(item)).toList();
      _datos = _inspecciones
          .map(
            (e) => {
          'id': e.id.toString(),
          'inspector': e.inspector,
          'fecha_inspeccion': e.fechaInspeccion.toIso8601String(),
        },
      )
          .toList();
      _datosFiltrados = List.from(_datos);
    });
  }

  void _filtrarDatos() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _datosFiltrados = _datos.where((elemento) {
        return elemento['id'].toLowerCase().contains(query);
      }).toList();
    });
  }

  DataRow toElement(Map<String, dynamic> elemento) {
    var date = DateTime.parse(elemento['fecha_inspeccion']);
    var fechaFormateada =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    return DataRow(
      cells: [
        DataCell(Text(elemento['id'].toString())),
        DataCell(Text(elemento['inspector'].toString())),
        DataCell(Text(fechaFormateada)),
        DataCell(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              side: BorderSide(width: 1, color: Color(0xffF29E23)),
            ),
            onPressed: () {
              _mostrarDetalles(context, elemento);
            },
            child: Text(
              "Ver detalle",
              style: GoogleFonts.poppins(color: Color(0xffF29E23)),
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalles(BuildContext context, Map<String, dynamic> datos) {
    var date = DateTime.parse(datos['fecha_inspeccion']);
    var fechaFormateada =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID Inspección: ${datos['id']}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Inspector: ${datos['inspector']}",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Fecha Inspección: $fechaFormateada",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.edit, color: Color(0xffF29E23)),
                    label: Text(
                      "Gestionar",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      debugPrint("Gestionar inspección para ${datos['id']}");
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.delete, color: Color(0xffF29E23)),
                    label: Text(
                      "Eliminar",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      debugPrint("Eliminar la inspección de ${datos['id']}");
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Color(0xFFEBEBEB), // Mismo color de fondo
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("notificaciones")));
                    },
                    icon: Icon(Icons.notifications, color: Colors.black),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  "Últimas inspecciones del puente",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                side: BorderSide(width: 1, color: Color(0xffF29E23)),
              ),
              onPressed: () {
                debugPrint("nueva inspeccion");
              },
              child: Text(
                "Nueva inspeccion",
                style: GoogleFonts.poppins(color: Color(0xffF29E23)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filtrarDatos();
              },
            ),
            SizedBox(height: 18),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFFFFFFF),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: 120,
                          child: Text(
                            "Nombre puente",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(label: Text("Ultima modificación")),
                      DataColumn(label: Text("")),
                    ],
                    rows: _datosFiltrados.map(toElement).toList(),
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
