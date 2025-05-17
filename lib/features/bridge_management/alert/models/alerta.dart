class Alerta {
  final int id;
  final int inspeccionId;
  final String tipo;
  final String mensaje;

  Alerta({
    required this.id,
    required this.inspeccionId,
    required this.tipo,
    required this.mensaje,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: json['id'],
      inspeccionId: json['inspeccionId'],
      tipo: json['tipo'],
      mensaje: json['mensaje'],
    );
  }
}