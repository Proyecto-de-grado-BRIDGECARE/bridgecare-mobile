class Reparacion {
  final int? id;
  final String tipo;
  final int cantidad;
  final int anio;
  final double costo;
  final int componenteId;

  Reparacion({
    this.id,
    required this.tipo,
    required this.cantidad,
    required this.anio,
    required this.costo,
    required this.componenteId,
  });

  static const Map<String, dynamic> formFields = {
    'tipo': {'type': 'text', 'label': 'Tipo'},
    'cantidad': {'type': 'number', 'label': 'Cantidad'},
    'anio': {'type': 'number', 'label': 'Año'},
    'costo': {'type': 'number', 'label': 'Costo'},
  };
}
