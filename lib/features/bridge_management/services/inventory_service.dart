import 'dart:convert';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/inventario.dart';
import 'package:http/http.dart' as http;

class InventarioService {
  static const String baseUrl =
      "http://localhost:8082/api/inventario"; // Temporary backend URL

  //get all inventories
  Future<List<Inventario>> getInventarios() async {
    final response = await http.get(Uri.parse("$baseUrl"));

    if (response == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Inventario.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar inventarios');
    }
  }
}
