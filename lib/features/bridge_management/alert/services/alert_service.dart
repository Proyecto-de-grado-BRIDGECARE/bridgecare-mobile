import 'dart:convert';
import 'package:bridgecare/features/bridge_management/alert/models/alerta.dart';
import 'package:http/http.dart' as http;


class AlertService {
  final String baseUrl = 'http://172.28.80.1:8086/api/alertas';

  Future<List<Alerta>> getAlertasPorInspeccion(int idInspeccion) async {
    final response = await http.get(Uri.parse('$baseUrl/inspeccion/$idInspeccion'));
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Alerta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar alertas por inspección');
    }
  }

  Future<List<Alerta>> getAlertasPorPuente(int idPuente) async {
    final response = await http.get(Uri.parse('$baseUrl/puente/$idPuente'));
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Alerta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar alertas por puente');
    }
  }
}