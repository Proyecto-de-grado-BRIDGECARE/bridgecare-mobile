import 'package:bridgecare/features/bridge_management/inspection/models/models.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class InspectionController with ChangeNotifier {
  final int puenteId;
  final List<Map<String, String>> componentList;
  final DatabaseService databaseService;
  final QueueService queueService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Inspeccion inspeccion;
  Map<String, dynamic> puenteData = {};
  bool _isWidgetVisible = false;

  InspectionController({
    required this.puenteId,
    required this.componentList,
    required this.databaseService,
    required this.queueService,
  }) : inspeccion = Inspeccion(
    inspeccionUuid: const Uuid().v4(),
    tiempo: 0,
    temperatura: 0,
    administrador: '',
    anioProximaInspeccion: 0,
    fecha: DateTime.now(),
    componentes: componentList
        .asMap()
        .entries
        .map((entry) => Componente(
      componenteUuid: const Uuid().v4(),
      name: entry.value['title']!
          .replaceAll('/', ' ')
          .toUpperCase(),
    ))
        .toList(),
  );


  bool get isWidgetVisible => _isWidgetVisible;

  void setPuenteData(Map<String, dynamic> data) {
    puenteData = data;
    // Removed notifyListeners() to avoid build-time updates
  }

  void updatePuenteData(Map<String, dynamic> data) {
    puenteData.addAll(data);
    notifyListeners();
  }

  void updateInspeccionData(Map<String, dynamic> data) {
    if (data['fecha'] != null) {
      final parsed = DateTime.tryParse(data['fecha'].toString());
      if (parsed != null) {
        inspeccion.fecha = parsed;
        debugPrint("📅 Fecha asignada correctamente: ${parsed.toIso8601String()}");
      } else {
        debugPrint("❌ No se pudo parsear la fecha: ${data['fecha']}");
      }
    }

    if (data['observacionesGenerales'] is String) {
      inspeccion.observacionesGenerales = data['observacionesGenerales'];
    }

    // Otros campos si los agregas más adelante como tiempo, temperatura, etc.

    notifyListeners();
  }

  void updateComponenteData(int index, Map<String, dynamic> data) {
    final componente = inspeccion.componentes[index];
    if (data['calificacion'] is String) {
      final match = RegExp(r'^(\d+)\s*-').firstMatch(data['calificacion']);
      componente.calificacion =
          match != null ? int.parse(match.group(1)!) : null;
    }
    componente.mantenimiento =
        data['mantenimiento'] ?? componente.mantenimiento;
    componente.inspEesp = data['inspEesp'] ?? componente.inspEesp;
    componente.numeroFfotos =
        int.tryParse(data['numeroFfotos']?.toString() ?? '0') ??
            componente.numeroFfotos;
    if (data['tipoDanio'] is String) {
      final match = RegExp(r'^(\d+)\s*-').firstMatch(data['tipoDanio']);
      componente.tipoDanio = match != null ? int.parse(match.group(1)!) : null;
    }
    componente.danio = data['danio'] ?? componente.danio;
    if (data['imagenUrls'] is List) {
      componente.imageUuids = (data['imagenUrls'] as List).map((file) {
        final imageData = ImageData(
          inspeccionUuid: inspeccion.inspeccionUuid,
          componenteUuid: componente.componenteUuid,
          imageUuid: const Uuid().v4(),
          puenteId: puenteId.toString(),
          localPath: file.path,
          createdAt: DateTime.now().toIso8601String(),
          uploadStatus: 'pending',
          chunkCount: 0,
          chunksUploaded: 0,
        );
        addImage(componente.componenteUuid, imageData);
        return imageData.imageUuid;
      }).toList();
    }
    notifyListeners();
  }

  void updateReparacionData(int index, Map<String, dynamic> data) {
    final componente = inspeccion.componentes[index];
    componente.reparacion = Reparacion(
      tipo: data['tipo'] ?? '',
      cantidad: int.tryParse(data['cantidad']?.toString() ?? '0') ?? 0,
      anio: int.tryParse(data['anio']?.toString() ?? '0') ?? 0,
      costo: double.tryParse(data['costo']?.toString() ?? '0') ?? 0,
    );
    notifyListeners();
  }

  Future<List<ImageData>> getImagesForComponente(String componenteUuid) async {
    final db = await databaseService.database;
    final maps = await db.query(
      'images',
      where: 'componente_uuid = ?',
      whereArgs: [componenteUuid],
    );
    return maps.map((map) => ImageData.fromMap(map)).toList();
  }

  Future<void> addImage(String componenteUuid, ImageData imageData) async {
    await databaseService.insertImage(imageData);
    notifyListeners();
  }

  void hideWidget() {
    _isWidgetVisible = false;
    notifyListeners();
  }

  Future<void> submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')??'';
    final usuarioId = prefs.getInt('usuario_id');

    if (token == null || token.isEmpty || usuarioId == null) {
      debugPrint("❌ Token o usuario_id no disponible");
      throw Exception("Token o usuario_id no disponible");
    }
    final decoded = JwtDecoder.decode(token);
    debugPrint("🔍 Token decodificado: $decoded");

    if (!formKey.currentState!.validate()) {
      debugPrint("❌ Formulario no válido");
      return;
    }
    debugPrint("🧾 usuarioId = $usuarioId");
    debugPrint("🌉 puenteId = $puenteId");
    formKey.currentState!.save();
    if (usuarioId == null || puenteId == null) {
      throw Exception("usuarioId o puenteId no están definidos");
    }
    final inspeccionJson = inspeccion.toJson(
      puenteId: puenteId,
      usuarioId: usuarioId,
    );

    final encodedJson = jsonEncode(inspeccionJson);
    debugPrint("📤 JSON de inspección a enviar:\n$encodedJson");

    final url = Uri.parse('https://api.bridgecare.com.co/inspeccion/add');


    debugPrint("📤 Enviando POST a: $url");
    debugPrint("🔐 Token (cortado): ${token.substring(0, 20)}...");
    final encoded = const JsonEncoder.withIndent('  ').convert(inspeccionJson);
    debugPrint("📦 Payload inspección (legible):\n$encoded");


    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: encodedJson,
    );

    debugPrint("📥 Respuesta: statusCode = ${response.statusCode}");
    debugPrint("📥 Body: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al guardar inspección: ${response.statusCode}");
    }

    debugPrint("✅ Inspección enviada correctamente");
  }


}
