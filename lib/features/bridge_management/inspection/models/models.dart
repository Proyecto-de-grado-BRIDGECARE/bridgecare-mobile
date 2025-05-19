import 'package:uuid/uuid.dart';

class Inspeccion {
  String inspeccionUuid;
  int puenteId;
  int usuarioId;
  Map<String, dynamic> inspeccionData; // e.g., fecha, tiempo
  List<Componente> componentes;

  Inspeccion({
    String? inspeccionUuid,
    required this.puenteId,
    required this.usuarioId,
    required this.inspeccionData,
    required this.componentes,
  }) : inspeccionUuid = inspeccionUuid ?? Uuid().v4();

  Map<String, dynamic> toJson() => {
        'inspeccionUuid': inspeccionUuid,
        'puente': {'id': puenteId},
        'usuario': {'id': usuarioId},
        ...inspeccionData,
        'componentes': componentes.map((c) => c.toJson()).toList(),
      };
}

class Componente {
  String componenteUuid;
  String nombre;
  Map<String, dynamic> componenteData; // e.g., calificacion, tipoDanio
  List<Reparacion> reparaciones;
  List<ImageData> images;

  Componente({
    String? componenteUuid,
    required this.nombre,
    required this.componenteData,
    required this.reparaciones,
    this.images = const [],
  }) : componenteUuid = componenteUuid ?? Uuid().v4();

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        ...componenteData,
        'reparaciones': reparaciones.map((r) => r.toJson()).toList(),
        'imagenUrls': images.map((i) => i.serverUrl).where((url) => url.isNotEmpty).toList(),
      };
}

class Reparacion {
  Map<String, dynamic> reparacionData; // e.g., tipo, cantidad, anio, costo

  Reparacion({required this.reparacionData});

  Map<String, dynamic> toJson() => reparacionData;
}

class ImageData {
  int? id;
  String inspeccionUuid;
  String componenteUuid;
  String imageUuid;
  String puenteId;
  String uploadStatus;
  int chunkCount;
  int chunksUploaded;
  String localPath;
  String serverUrl;
  String createdAt;

  ImageData({
    this.id,
    required this.inspeccionUuid,
    required this.componenteUuid,
    required this.imageUuid,
    required this.puenteId,
    this.uploadStatus = 'pending',
    this.chunkCount = 0,
    this.chunksUploaded = 0,
    required this.localPath,
    this.serverUrl = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'inspeccion_uuid': inspeccionUuid,
        'componente_uuid': componenteUuid,
        'image_uuid': imageUuid,
        'puente_id': puenteId,
        'upload_status': uploadStatus,
        'chunk_count': chunkCount,
        'chunks_uploaded': chunksUploaded,
        'local_path': localPath,
        'server_url': serverUrl,
        'created_at': createdAt,
      };

  factory ImageData.fromMap(Map<String, dynamic> map) => ImageData(
        id: map['id'],
        inspeccionUuid: map['inspeccion_uuid'],
        componenteUuid: map['componente_uuid'],
        imageUuid: map['image_uuid'],
        puenteId: map['puente_id'],
        uploadStatus: map['upload_status'],
        chunkCount: map['chunk_count'],
        chunksUploaded: map['chunks_uploaded'],
        localPath: map['local_path'],
        serverUrl: map['server_url'],
        createdAt: map['created_at'],
      );
}