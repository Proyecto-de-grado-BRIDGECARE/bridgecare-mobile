import 'dart:convert';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/inventario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InventarioService {
  static const String baseUrl =
        //"http://192.168.1.5:8082/api/inventario";
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

  Future<void> eliminarInventario(int inventarioId) async {
    final response = await http.delete(Uri.parse("$baseUrl/$inventarioId"));

    if (response.statusCode == 200) {
      debugPrint('Inventario eliminado');
    } else {
      throw Exception('Error al eliminar inventario');
    }
  }
}
