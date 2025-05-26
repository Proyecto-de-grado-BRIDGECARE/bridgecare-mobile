import 'dart:convert';
import 'package:bridgecare/features/bridge_management/alert/models/alerta.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlertService {
  final String baseUrl = 'https://api.bridgecare.com.co/alerta';

  Future<List<Alerta>> getAlertasPorInspeccion(int idInspeccion) async {
    final response =
        await http.get(Uri.parse('$baseUrl/inspeccion/$idInspeccion'));
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Alerta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar alertas por inspección');
    }
  }

  Future<List<Alerta>> getAlertasPorPuente(int puenteId) async {
    final prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');
    debugPrint('Token: $token');

    final response = await http.get(
      Uri.parse('$baseUrl/puente/$puenteId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((json) => Alerta.fromJson(json)).toList();
    } else {
      debugPrint('❌ Error al obtener alertas: ${response.statusCode}');
      debugPrint('❌ Body: ${utf8.decode(response.bodyBytes)}');
      throw Exception('Error al cargar alertas por puente');
    }
  }
}
