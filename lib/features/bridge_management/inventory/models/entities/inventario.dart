class Inventario {
  final int? id;
  final String observaciones;
  final int puenteId;
  final int usuarioId;

  Inventario({
    this.id,
    required this.observaciones,
    required this.puenteId,
    required this.usuarioId,
  });

  static const Map<String, dynamic> formFields = {
    'observaciones': {'type': 'text', 'label': 'Observaciones'},
  };
}
