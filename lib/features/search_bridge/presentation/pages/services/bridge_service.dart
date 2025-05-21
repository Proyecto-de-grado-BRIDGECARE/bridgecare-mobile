import 'dart:convert';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BridgeService {
  final String baseUrl =
      //"http://192.168.1.9:8081/api/puentes";
      "https://api.bridgecare.com.co/puentes";

  Future<List<Puente>> getAllPuentes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró token de autenticación.");
    }

    // Imprimir el token en consola
    debugPrint('Token enviado: $token');

    final response = await http.get(
      Uri.parse("$baseUrl/all"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('📡 Status code: ${response.statusCode}');
    debugPrint('📡 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Puente.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception(
          "🔒 No autorizado: El token puede ser inválido o expirado.");
    } else {
      throw Exception("❌ Error al obtener puentes: ${response.statusCode}");
    }
  }

  Future<void> deletePuente(int id) async {
    final url =
        Uri.parse('$baseUrl/$id'); // ✅ concuerda con tu @DeleteMapping("/{id}")
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el puente: ${response.body}');
    }
  }

  Future<void> deletePuenteCascada(int puenteId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token no encontrado");
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/cascada/$puenteId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar el puente: ${response.body}");
    }
  }
}
