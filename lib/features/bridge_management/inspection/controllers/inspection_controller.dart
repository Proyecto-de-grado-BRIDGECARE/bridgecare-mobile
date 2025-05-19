import 'package:bridgecare/features/bridge_management/inspection/models/models.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:flutter/material.dart';
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
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) {
      throw Exception('No se pudo obtener el usuario autenticado');
    }

    final payload = {
      'inspeccionUuid': inspeccion.inspeccionUuid,
      'fecha': inspeccion.fecha,
      'observacionesGenerales': inspeccion.observacionesGenerales,
      'usuario': {'id': usuarioId},
      'puente': {'id': puenteId},
      'componentes': inspeccion.componentes
          .map((c) => {
                'componenteUuid': c.componenteUuid,
                'nomb': c.name,
                'calificacion': c.calificacion,
                'mantenimiento': c.mantenimiento,
                'inspEesp': c.inspEesp,
                'numeroFfotos': c.numeroFfotos,
                'tipoDanio': c.tipoDanio,
                'danio': c.danio,
                'reparacion':
                    c.reparacion != null ? [c.reparacion!.toJson()] : [],
                'imageUuids': c.imageUuids,
              })
          .toList(),
    };

    await databaseService.insertForm(
      inspeccion.inspeccionUuid,
      jsonEncode(payload),
      puenteId.toString(),
    );

    final taskData = jsonEncode({
      'inspeccion_uuid': inspeccion.inspeccionUuid,
    });
    final dependsOn = inspeccion.componentes
        .where((c) => c.imageUuids.isNotEmpty)
        .map((c) => c.imageUuids.join(','))
        .join(',');
    await databaseService.enqueueTask(
      taskType: 'inspeccion_submit',
      data: taskData,
      dependsOn: dependsOn.isNotEmpty ? dependsOn : null,
    );

    _isWidgetVisible = true;
    notifyListeners();
  }
}
