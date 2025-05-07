import 'dart:convert';
import 'package:bridgecare/features/user_management/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl = "http://192.168.1.16:8084/api/usuarios"; // cambia IP según backend

  Future<List<Usuario>> getAllUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Asegúrate de que 'token' esté guardado correctamente

    if (token == null || token.isEmpty) {
      throw Exception("No se encontró token de autenticación.");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/users"), // Ruta completa: /api/usuarios/users
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📡 Código de estado: ${response.statusCode}');
    print('📡 Respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Usuario.fromJson(e)).toList();
    } else if (response.statusCode == 403) {
      throw Exception("Acceso prohibido: el token no tiene permisos suficientes.");
    } else if (response.statusCode == 401) {
      throw Exception("No autorizado: el token es inválido o expiró.");
    } else {
      throw Exception("Error al obtener usuarios: ${response.statusCode}");
    }
  }
  Future<void> registerUsuario(Usuario nuevoUsuario) async {
    final url = Uri.parse("http://192.168.1.16:8084/api/usuarios/register");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(nuevoUsuario.toJson()), // Asegúrate que Usuario tenga toJson()
    );

    print('📨 Registro status code: ${response.statusCode}');
    print('📨 Registro response: ${response.body}');
    if (response.statusCode != 200) {
      final body = response.body.trim();

      if (body.isNotEmpty) {
        try {
          final error = jsonDecode(body);
          throw Exception("Error al registrar usuario: ${error["message"] ?? body}");
        } catch (_) {
          throw Exception("Error al registrar usuario: $body");
        }
      } else {
        throw Exception("Error al registrar usuario: respuesta vacía");
      }
    }

    if (response.statusCode == 200) {
      print("✅ Usuario registrado correctamente");
    } else {
      final error = jsonDecode(response.body);
      throw Exception("Error al registrar usuario: ${error["message"] ?? response.statusCode}");
    }
  }

}
  /*
  Future<void> deleteUsuario(String idUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró token de autenticación.");
    }

    print('Token enviado para eliminar: $token');

    final response = await http.delete(
      Uri.parse("$baseUrl/$idUsuario"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('🗑️ Delete status code: ${response.statusCode}');
    print('🗑️ Delete response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(" Error al eliminar usuario: ${response.statusCode}");
    }
  }*/


