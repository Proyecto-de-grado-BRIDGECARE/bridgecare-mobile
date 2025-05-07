import 'dart:convert';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BridgeService {
  final String baseUrl = "http://192.168.1.16:8081/api/puentes";

  Future<List<Puente>> getAllPuentes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró token de autenticación.");
    }

    // Imprimir el token en consola
    print('Token enviado: $token');

    final response = await http.get(
      Uri.parse("$baseUrl/all"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📡 Status code: ${response.statusCode}');
    print('📡 Response body: ${response.body}');

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
}
