import 'package:uuid/uuid.dart';

class Inspeccion {
  String inspeccionUuid;
  String? fecha;
  String? observacionesGenerales;
  List<Componente> componentes;

  Inspeccion({
    String? inspeccionUuid,
    this.fecha,
    this.observacionesGenerales,
    required this.componentes,
  }) : inspeccionUuid = inspeccionUuid ?? const Uuid().v4();

  Map<String, dynamic> toJson({required int puenteId, required int usuarioId}) => {
        'inspeccionUuid': inspeccionUuid,
        'fecha': fecha,
        'observacionesGenerales': observacionesGenerales,
        'componentes': componentes.map((c) => c.toJson()).toList(),
      };
}

class Componente {
  String componenteUuid;
  String name;
  int? calificacion;
  String mantenimiento;
  String inspEesp;
  int numeroFfotos;
  int? tipoDanio;
  String danio;
  Reparacion? reparacion;
  List<String> imageUuids;

  Componente({
    String? componenteUuid,
    required this.name,
    this.calificacion,
    this.mantenimiento = '',
    this.inspEesp = '',
    this.numeroFfotos = 0,
    this.tipoDanio,
    this.danio = '',
    this.reparacion,
    this.imageUuids = const [],
  }) : componenteUuid = componenteUuid ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'componenteUuid': componenteUuid,
        'nomb': name,
        'calificacion': calificacion,
        'mantenimiento': mantenimiento,
        'inspEesp': inspEesp,
        'numeroFfotos': numeroFfotos,
        'tipoDanio': tipoDanio,
        'danio': danio,
        'reparacion': reparacion?.toJson(),
      };
}

class Reparacion {
  String tipo;
  int cantidad;
  int anio;
  double costo;

  Reparacion({
    this.tipo = '',
    this.cantidad = 0,
    this.anio = 0,
    this.costo = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'cantidad': cantidad,
        'anio': anio,
        'costo': costo,
      };
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
  String createdAt;
  String? remoteUrl;

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
    required this.createdAt,
    this.remoteUrl,
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
        createdAt: map['created_at'],
        remoteUrl: map['remote_url'],
      );
}
