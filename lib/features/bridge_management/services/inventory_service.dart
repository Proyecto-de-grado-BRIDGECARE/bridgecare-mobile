import 'dart:convert';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/inventario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../inventory/models/dtos/inventario_dto.dart';

class InventarioService {
  static const String baseUrl =
        //"http://192.168.0.105:8082/api/inventario";
      "https://api.bridgecare.com.co/inventario"; // Temporary backend URL

  //get all inventories
  Future<List<Inventario>> getInventarios() async {
    final response = await http.get(Uri.parse("$baseUrl/all"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Inventario.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar inventarios');
    }
  }

  Future<Inventario?> getInventarioPorPuente(int puenteId) async {
    final response = await http.get(Uri.parse("$baseUrl/por-puente/$puenteId"));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return Inventario.fromJson(jsonDecode(response.body));
      } else {
        return null; // no existe inventario
      }
    } else if (response.statusCode == 404) {
      return null; // backend devuelve 404 si no existe
    } else {
      throw Exception('Error al obtener inventario del puente');
    }
  }
  Future<InventarioDTO?> getInventarioDTOporPuente(int puenteId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    debugPrint("📥 Token para GET inventario por puente: $token");

    final response = await http.get(
      Uri.parse("$baseUrl/puente/$puenteId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('🔁 Status code: ${response.statusCode}');
    debugPrint('🔁 Body: ${response.body}');

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return InventarioDTO.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null; // Inventario no encontrado
    } else {
      throw Exception('Error al obtener inventario del puente: ${response.statusCode}');
    }
  }

  Future<void> eliminarInventario(int inventarioId) async {
    final response = await http.delete(Uri.parse("$baseUrl/$inventarioId"));

    if (response.statusCode == 200) {
      debugPrint('Inventario eliminado');
    } else {
      throw Exception('Error al eliminar inventario');
    }
  }
}
