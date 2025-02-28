import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bridgecare/features/assets/domain/models/Usuarios.dart';

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
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    final url = Uri.parse("https://tu-api.com/usuarios");
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _usuarios = data.map((item) => Usuario.fromJson(item)).toList();

          _datos = _usuarios
              .map((u) => {
                    'id': u.id,
                    'noId': u.noId,
                    'nombre': u.nombre,
                    'correo': u.correo,
                    'tipoUsuario': u.tipoUsuario
                  })
              .cast<Map<String, dynamic>>()
              .toList();

          _datosFiltrados = List.from(_datos);
          _isLoading = false;
          _hasError = false;
        });
      } else {
        throw Exception("Error en la respuesta del servidor");
      }
    } catch (e) {
      print("error al cargar usuarios: $e");

      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener datos del servidor")),
      );
    }
  }

  void _filtrarDatos() {
    String query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _datosFiltrados = List.from(_datos);
        return;
      }

      _datosFiltrados = _datos.where((elemento) {
        String id = elemento['id']?.toLowerCase() ?? '';
        String nombre = elemento['nombre']?.toLowerCase() ?? '';
        String correo = elemento['correo']?.toLowerCase() ?? '';

        return id.contains(query) ||
            nombre.contains(query) ||
            correo.contains(query);
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
            _mostrarDialogoEliminar(elemento['id']);
          }))
    ]);
  }

  void _mostrarDialogoEliminar(String idUsuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar usuario"),
          content: Text("¿Seguro que quieres eliminar este usuario?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () {
                setState(() {
                  _usuarios.removeWhere((u) => u.id == idUsuario);
                  _datos.removeWhere((u) => u['id'] == idUsuario);
                  _datosFiltrados.removeWhere((u) => u['id'] == idUsuario);
                });
                Navigator.pop(context);
              },
            ),
          ],
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
                  hintText: "Buscar usuario...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                ),
                onChanged: (value) {
                  _filtrarDatos();
                },
              ),

              SizedBox(height: 20),

              // Estado de carga o error
              if (_isLoading) Center(child: CircularProgressIndicator()),
              if (_hasError)
                Center(
                    child: Text("Error al cargar datos",
                        style: TextStyle(color: Colors.red))),
              //tabla de usuarios

              if (!_isLoading && !_hasError)
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
