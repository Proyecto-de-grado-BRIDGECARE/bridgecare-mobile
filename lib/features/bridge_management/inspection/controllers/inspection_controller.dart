import 'package:bridgecare/features/bridge_management/inspection/models/models.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    if (data['fecha'] is String) {
      inspeccion.fecha = data['fecha'];
    }
    if (data['observacionesGenerales'] is String) {
      inspeccion.observacionesGenerales = data['observacionesGenerales'];
    }
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
    final token = prefs.getString('token');
    final usuarioId = prefs.getInt('usuario_id');

    if (token == null || token.isEmpty || usuarioId == null) {
      throw Exception("Token o usuario_id no disponible");
    }

    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    final inspeccionJson = inspeccion.toJson(
      puenteId: puenteId,
      usuarioId: usuarioId,
    );

    final response = await http.post(
      Uri.parse('https://api.bridgecare.com.co/inspeccion/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(inspeccionJson),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al guardar inspección: ${response.statusCode}");
    }

    debugPrint("✅ Inspección enviada correctamente: ${response.body}");
  }

}
