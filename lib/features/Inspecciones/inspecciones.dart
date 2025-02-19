import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class Inspeccion {
  final String id;
  final String mail;
  final DateTime date;

  Inspeccion({required this.id, required this.mail, required this.date});

  factory Inspeccion.fromJson(Map<String, dynamic> json) {
    // Buscamos la primera clave que no sea 'mail' ni 'date' (asumimos que es el id)
    String idKey = json.keys.firstWhere((key) => key != 'mail' && key != 'date',
        orElse: () => 'desconocido'); // Evita errores si el id no existe

    return Inspeccion(
      id: json[idKey] ?? 'Sin ID',
      mail: json['mail'] ?? 'Sin correo',
      date: json['date'] ?? 'Sin fecha',
    );
  }
}

class InspeccionesPage extends StatefulWidget {
  @override
  State<InspeccionesPage> createState() => _InspectionState();
}

class _InspectionState extends State<InspeccionesPage> {
  List<Inspeccion> _inspecciones = [];
  List<Map<String, dynamic>> _datos = []; // Datos originales
  List<Map<String, dynamic>> _datosFiltrados = []; // Datos filtrados
  TextEditingController _searchController = TextEditingController();
  late String _idPuente;

  @override
  void initState() {
    super.initState();
    _cargarJson();
  }

  Future<void> _cargarJson() async {
    final String jsonData =
        await rootBundle.loadString('assets/inspecciones.json');
    final List<dynamic> data = await json.decode(jsonData);

    setState(() {
      _idPuente = data.first["idPuente"];

      _inspecciones =
          data.skip(1).map((item) => Inspeccion.fromJson(item)).toList();

      //convertir Inspeccion a map<Strig, dynamic>
      _datos = _inspecciones
          .map((e) => {'id': e.id, 'mail': e.mail, 'date': e.date.toString()})
          .cast<Map<String, dynamic>>()
          .toList();

      _datosFiltrados = List.from(_datos);
    });
  }

  void _filtrarDatos() {
    String Query = _searchController.text.toLowerCase();

    setState(() {
      _datosFiltrados = _datos.where((elemento) {
        return elemento['id'].toLowerCase().contains(Query);
      }).toList();
    });
  }

  DataRow toElement(Map<String, dynamic> elemento) {
    var date = DateTime.parse(elemento['date']);
    var fechaFormateada =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    return DataRow(cells: [
      DataCell(Text(elemento['id'].toString())),
      DataCell(Text(fechaFormateada)),
      DataCell(ElevatedButton(
        child: Text("ver detalle",
            style: GoogleFonts.poppins(color: Color(0xffF29E23))),
        style: ElevatedButton.styleFrom(
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            side: BorderSide(width: 1, color: Color(0xffF29E23))),
        onPressed: () {
          _mostrarDetalles(context, elemento);
        },
      ))
    ]);
  }

  void _mostrarDetalles(BuildContext context, Map<String, dynamic> datos) {
    var date = DateTime.parse(datos['date']);
    var fechaFormateada =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "No. ",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "ID Inspección",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "No. ",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    Text(
                      datos['id'] ?? "sin id",
                      style: GoogleFonts.poppins(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Usuario encargado",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  datos['mail'] ?? "sin mail",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  "Fecha inspección",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  fechaFormateada ?? "sin fecha",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Color(0xffF29E23)),
                      label: Text("gestionar inspeccion",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print("Gestionar inspección para ${datos['id']}");
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.delete, color: Color(0xffF29E23)),
                      label: Text("eliminar inspeccion",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print("eliminar la inspeccion de ${datos['id']}");
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEBEBEB),
        appBar: AppBar(
            title: Text(
              "Ultimas inspecciones del puente",
              style: TextStyle(color: Colors.black, fontSize: 19),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFFEBEBEB)),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              ElevatedButton(
                child: Text("Nueva inspeccion",
                    style: GoogleFonts.poppins(color: Color(0xffF29E23))),
                style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    side: BorderSide(width: 1, color: Color(0xffF29E23))),
                onPressed: () {
                  print("nueva inspeccion");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search)),
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
                        child: DataTable(columns: [
                          DataColumn(
                              label: SizedBox(
                            width: 120,
                            child: Text("Nombre puente",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
                          )),
                          DataColumn(label: Text("Ultima modificación")),
                          DataColumn(label: Text("")),
                        ], rows: _datosFiltrados.map(toElement).toList()),
                      )))
            ])));
  }
}
