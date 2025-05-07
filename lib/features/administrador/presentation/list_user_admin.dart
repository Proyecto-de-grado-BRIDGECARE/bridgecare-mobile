import 'package:bridgecare/features/administrador/presentation/user_auth.dart';
import 'package:bridgecare/features/administrador/presentation/usuarios_admin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bridgecare/features/user_management/models/usuario.dart';

import '../../user_management/services/usuario_service.dart';

class UsuariosListAdminScreen extends StatefulWidget {
  UsuariosListAdminScreen({super.key});

  @override
  State<UsuariosListAdminScreen> createState() => _UsuariosListAdminState();
}

class _UsuariosListAdminState extends State<UsuariosListAdminScreen> {
  bool isFirstChecked = true;
  bool isSecondChecked = false;
  final UserService _usuarioService = UserService();
  List<Usuario> _usuarios = [];
  List<Usuario> _usuariosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    try {
      final data = await _usuarioService.getAllUsuarios();
      setState(() {
        _usuarios = data;
        _usuariosFiltrados = data;
      });
    } catch (e) {
      print("Error al cargar usuarios: $e");
    }
  }

  void _buscar(String texto) {
    final query = texto.toLowerCase();
    setState(() {
        _usuariosFiltrados = _usuarios
            .where((usuario) => usuario.nombres.toLowerCase().contains(query))
            .toList();
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
                              builder: (context) => const UsuariosAdmin()),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Administrar Usuarios',
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  hintText: 'Escribe el nombre del usuario',
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
                                  print("Filtrar por usuario: $value");
                                  _buscar(value);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                print("Buscar Usuario");
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
                  ],
                ),
              ),

              SizedBox(height: 16),
              // Lista de usuarios
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
                            itemCount: _usuariosFiltrados.length,
                            itemBuilder: (context, index) {
                              final usuario = _usuariosFiltrados[index];
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
                                      Text("Nombre: ${usuario.nombres}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text("Apellidos: ${usuario.apellidos}"),
                                      const SizedBox(height: 12),
                                      Text("tipoUsuario: ${usuario.tipoUsuario}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),

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

  /*DataRow toElement(Map<String, dynamic> usuario) {
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
        content: const Text("¿Estás seguro de que deseas eliminar este usuario?"),
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
  }*/
}

