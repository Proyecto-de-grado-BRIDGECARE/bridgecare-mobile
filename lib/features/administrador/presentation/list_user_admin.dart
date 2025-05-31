import 'package:bridgecare/features/user_management/create_user/presentation/pages/create_user.dart';
import 'package:bridgecare/features/user_management/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:bridgecare/features/user_management/models/usuario.dart';

class UsuariosListAdminScreen extends StatefulWidget {
  const UsuariosListAdminScreen({super.key});

  @override
  State<UsuariosListAdminScreen> createState() => _UsuariosListAdminState();
}

class _UsuariosListAdminState extends State<UsuariosListAdminScreen> {
  bool isFirstChecked = true;
  bool isSecondChecked = false;
  final UserService _usuarioService = UserService();
  List<Usuario> _usuarios = [];
  List<Usuario> _usuariosFiltrados = [];
  String obtenerTipoUsuarioTexto(int tipo) {
    switch (tipo) {
      case 0:
        return 'Usuario Municipal';
      case 1:
        return 'Ingeniero';
      case 2:
        return 'Administrador';
      default:
        return 'Desconocido';
    }
  }

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
      debugPrint("Error al cargar usuarios: $e");
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
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      // ← Solución clave
                      child: Text(
                        'Administrar Usuarios',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // ← Evita overflow visual
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
                                  debugPrint("Filtrar por usuario: $value");
                                  _buscar(value);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                debugPrint("Buscar Usuario");
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
                                                    "Nombre: ${usuario.nombres}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                const SizedBox(height: 4),
                                                Text(
                                                    "Apellidos: ${usuario.apellidos}"),
                                                const SizedBox(height: 4),
                                                Text(
                                                    "Tipo Usuario: ${obtenerTipoUsuarioTexto(usuario.tipoUsuario)}",
                                                    style: const TextStyle(
                                                        fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  debugPrint(
                                                      "Editar usuario ${usuario.id}");
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegistroUsuario(
                                                              usuario: usuario),
                                                    ),
                                                  ).then(
                                                      (_) => _cargarUsuarios());
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () async {
                                                  final confirm =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          '¿Eliminar usuario?'),
                                                      content: const Text(
                                                          'Esta acción no se puede deshacer.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: const Text(
                                                              'Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true),
                                                          child: const Text(
                                                              'Eliminar'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    try {
                                                      await _usuarioService
                                                          .deleteUsuario(usuario
                                                              .id
                                                              .toString());
                                                      setState(() {
                                                        _usuarios.removeWhere(
                                                            (u) =>
                                                                u.id ==
                                                                usuario.id);
                                                        _usuariosFiltrados
                                                            .removeWhere((u) =>
                                                                u.id ==
                                                                usuario.id);
                                                      });
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  "Usuario eliminado")),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      debugPrint(
                                                          "Error al eliminar: $e");
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  "Error: $e")),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          )
                                        ],
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
