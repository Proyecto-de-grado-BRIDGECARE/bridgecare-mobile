import 'dart:convert';
import 'package:bridgecare/features/user_management/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl =
      //"http://192.168.0.105:8084/api/usuarios";
  "https://api.bridgecare.com.co/usuarios";

  Future<List<Usuario>> getAllUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("No se encontró token de autenticación.");
    debugPrint('Token enviado: $token');

    final response = await http.get(
      Uri.parse("$baseUrl/users"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('📡 Código de estado: ${response.statusCode}');
    debugPrint('📡 Respuesta: ${response.body}');

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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // solo si existe
    };

    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(nuevoUsuario.toJson()),
    );

    debugPrint('📨 Registro status code: ${response.statusCode}');
    debugPrint('📨 Registro response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
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

    debugPrint("✅ Usuario registrado correctamente");
  }

  Future<void> deleteUsuario(String idUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("No se encontró token de autenticación.");

    debugPrint('Token enviado para eliminar: $token');
    final response = await http.delete(
      Uri.parse("$baseUrl/users/$idUsuario"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('🗑️ Delete status code: ${response.statusCode}');
    debugPrint('🗑️ Delete response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(" Error al eliminar usuario: ${response.statusCode}");
    }
  }

  Future<void> updateUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("No se encontró token de autenticación.");

    final url = Uri.parse("$baseUrl/users/${usuario.id}");

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(usuario.toJson()),
    );

    debugPrint('✏️ Update status code: ${response.statusCode}');
    debugPrint('✏️ Update response: ${response.body}');

    if (response.statusCode != 200) {
      final body = response.body.trim();
      if (body.isNotEmpty) {
        try {
          final error = jsonDecode(body);
          throw Exception("Error al actualizar usuario: ${error["message"] ?? body}");
        } catch (_) {
          throw Exception("Error al actualizar usuario: $body");
        }
      } else {
        throw Exception("Error al actualizar usuario: respuesta vacía");
      }
    }
  }
}
