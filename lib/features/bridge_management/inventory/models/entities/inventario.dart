class Inventario {
  final int? id;
  final String observaciones;

  Inventario({
    this.id,
    required this.observaciones,
  });

  static const Map<String, dynamic> formFields = {
    'observaciones': {'type': 'text', 'label': 'Observaciones'},
  };
}
