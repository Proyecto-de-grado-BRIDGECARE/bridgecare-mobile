import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class Usuario {
  final String id;
  final String nombre;
  final String apellidos;
  final String noId;
  final String correo;
  final String municipio;
  final String contrasenia;
  final String tipoUsuario;

  Usuario(
      {required this.id,
      required this.nombre,
      required this.apellidos,
      required this.noId,
      required this.correo,
      required this.municipio,
      required this.contrasenia,
      required this.tipoUsuario});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    String idKey = json.containsKey('id')
        ? 'id'
        : json.containsKey('_id')
            ? '_id'
            : 'desconocido';

    return Usuario(
        id: json[idKey].toString() ?? 'desconocido',
        nombre: json['nombre'] ?? 'sin nombre',
        apellidos: json['apellidos'] ?? 'sin apellidos',
        noId: json['noId'] ?? 'sin noId',
        correo: json['correo'] ?? 'sin correo',
        municipio: json['municipio'] ?? 'sin municipio',
        contrasenia: json['contrasenia'] ?? 'sin contrasenia',
        tipoUsuario: json['tipoUsuario'] ?? 'sin tipo usuario');
  }
}

class listaUsuarios extends StatefulWidget {
  const listaUsuarios({super.key});

  @override
  State<StatefulWidget> createState() => _usuariosState();
}

class _usuariosState extends State<listaUsuarios> {
  List<Usuario> _usuarios = [];

  //datos para la barra de busqueda
  List<Map<String, dynamic>> _datos = [];
  List<Map<String, dynamic>> _datosFiltrados = [];

  TextEditingController _searchController = TextEditingController();
  late String _idUsuario;

  @override
  void initState() {
    super.initState();
    _cargarJson();
  }

  void _cargarJson() async {
    final String jsonData = await rootBundle.loadString('assets/usuarios.json');
    final List<dynamic> data = await json.decode(jsonData);

    setState(() {
      // Convertir la lista de JSON en una lista de objetos Usuario
      _usuarios = data.map((item) => Usuario.fromJson(item)).toList();

      //Convertir los objetos Usuario en una lista de mapas para su manejo en la UI
      _datos = _usuarios
          .map((u) => {
                'id': u.id,
                'nombre': u.nombre,
                'correo': u.correo,
                'tipoUsuario': u.tipoUsuario
              })
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
    return DataRow(cells: [
      DataCell(Text(elemento['noId'].toString())),
      DataCell(Text(elemento['nombre'].toString())),
      DataCell(IconButton(
          icon: Icon(Icons.edit),
          iconSize: 40,
          color: Color(0xffF29E23),
          onPressed: () {
            print('editar usuario');
          })),
      DataCell(IconButton(
          icon: Icon(Icons.delete),
          iconSize: 40,
          color: Color(0xffF29E23),
          onPressed: () {
            print('eliminar usuario');
          }))
    ]);
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
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("notificaciones")));
                          },
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.black,
                          ))
                    ]),
                Expanded(
                    child: Text(
                  "Lista de usuarios",
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
          )),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              //nuevo usuario
              ElevatedButton(
                  child: Text("Nuevo usuario",
                      style: GoogleFonts.poppins(color: Color(0xffF29E23))),
                  style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    print("buscar usuario");
                  }),
              const SizedBox(
                height: 20,
              ),
              //barra de busqueda
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
              SizedBox(height: 20),
              //tabla de usuarios
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
                        child: Text("No. Id",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 120,
                        child: Text("Nombre",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 120,
                        child: Text("editar",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 120,
                        child: Text("visualizar",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      )),
                    ], rows: _datosFiltrados.map(toElement).toList()),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
