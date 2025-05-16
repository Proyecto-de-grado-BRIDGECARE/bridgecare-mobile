class Inventario {
  final int? id;
  final String observaciones;
  final int puenteId;
  final int?
  usuarioId;

  Inventario({
    this.id,
    required this.observaciones,
    required this.puenteId,
    this.usuarioId,
  });

  static const Map<String, dynamic> formFields = {
    'observaciones': {'type': 'text', 'label': 'Observaciones'},
  };

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      id: json['id'],
      observaciones: json['observaciones'],
      puenteId: json['puente_id'],
      usuarioId: json['usuario_id'],
    );
  }
}
