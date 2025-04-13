import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bridgecare/features/user_management/models/usuario.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({super.key});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  List<Usuario> _usuarios = [];
  List<Map<String, dynamic>> _datos = [];
  List<Map<String, dynamic>> _datosFiltrados = [];

  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  Future<void> obtenerDatos() async {
    final url = Uri.parse("https://tu-api.com/usuarios");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _usuarios = data.map((item) => Usuario.fromJson(item)).toList();
          _datos = _usuarios
              .map((u) => {
                    'id': u.id,
                    'noId': u.identificacion,
                    'nombre': u.nombres,
                    'correo': u.correo,
                    'tipoUsuario': u.tipoUsuario,
                  })
              .toList();
          _datosFiltrados = List.from(_datos);
          _isLoading = false;
        });
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error al obtener datos: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _filtrarDatos() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _datosFiltrados = _datos.where((elemento) {
        return (elemento['nombre'] ?? '').toLowerCase().contains(query) ||
            (elemento['correo'] ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  DataRow toElement(Map<String, dynamic> usuario) {
    return DataRow(
      cells: [
        DataCell(Text(usuario['noId'])),
        DataCell(Text(usuario['nombre'])),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              Navigator.pushNamed(context, '/updateUser');
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _mostrarDialogoEliminar(usuario['id']);
            },
          ),
        ),
      ],
    );
  }

  void _mostrarDialogoEliminar(String idUsuario) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar usuario"),
        content:
            const Text("¿Estás seguro de que deseas eliminar este usuario?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _usuarios.removeWhere((u) => u.id == idUsuario);
                _datos.removeWhere((u) => u['id'] == idUsuario);
                _datosFiltrados.removeWhere((u) => u['id'] == idUsuario);
              });
              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff281537), Color(0xff1780cc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: const BoxDecoration(
                  color: Color(0xccffffff),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xff01579a)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Lista de usuarios",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.black),
                      onPressed: () {},
                    )
                  ],
                ),
              ),

              // Botón y campo de búsqueda
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/createUser'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Nuevo usuario",
                          style: TextStyle(color: Color(0xffF29E23))),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => _filtrarDatos(),
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Buscar por nombre o correo",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista o estados
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _hasError
                        ? const Center(
                            child: Text("Error al cargar usuarios",
                                style: TextStyle(color: Colors.red)))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xccffffff),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    columnSpacing: 30,
                                    columns: const [
                                      DataColumn(label: Text("ID")),
                                      DataColumn(label: Text("Nombre")),
                                      DataColumn(label: Text("Editar")),
                                      DataColumn(label: Text("Eliminar")),
                                    ],
                                    rows:
                                        _datosFiltrados.map(toElement).toList(),
                                  ),
                                ),
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
