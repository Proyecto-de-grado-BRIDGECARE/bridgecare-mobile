class Inspeccion {
  final int id;
  final String nombre;
  final String identificacion;
  final String carretera;
  final String pr;
  final DateTime fechaInspeccion;
  final String inspector;
  final DateTime? proximaInspeccion;
  final int? histInspecid;

  Inspeccion({
    required this.id,
    required this.nombre,
    required this.identificacion,
    required this.carretera,
    required this.pr,
    required this.fechaInspeccion,
    required this.inspector,
    this.proximaInspeccion,
    this.histInspecid,
  });

  factory Inspeccion.fromJson(Map<String, dynamic> json) {
    return Inspeccion(
      id: json['id'],
      nombre: json['nombre'],
      identificacion: json['identificacion'],
      carretera: json['carretera'],
      pr: json['pr'],
      fechaInspeccion: DateTime.parse(json['fecha_inspeccion']),
      inspector: json['inspector'],
      proximaInspeccion: json['proxima_inspeccion'] != null
          ? DateTime.parse(json['proxima_inspeccion'])
          : null,
      histInspecid: json['hist_inspecid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'identificacion': identificacion,
      'carretera': carretera,
      'pr': pr,
      'fecha_inspeccion': fechaInspeccion.toIso8601String(),
      'inspector': inspector,
      'proxima_inspeccion': proximaInspeccion?.toIso8601String(),
      'hist_inspecid': histInspecid,
    };
  }
}
