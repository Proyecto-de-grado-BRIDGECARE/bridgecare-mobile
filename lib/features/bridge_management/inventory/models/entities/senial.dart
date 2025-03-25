class Senial {
  final int? id;
  final String cargaMaxima;
  final String velocidadMaxima;
  final String otra;
  final int subestructuraId;

  Senial({
    this.id,
    required this.cargaMaxima,
    required this.velocidadMaxima,
    required this.otra,
    required this.subestructuraId,
  });

  static const Map<String, dynamic> formFields = {
    'cargaMaxima': {'type': 'text', 'label': 'Carga Máxima'},
    'velocidadMaxima': {'type': 'text', 'label': 'Velocidad Máxima'},
    'otra': {'type': 'text', 'label': 'Otra'},
  };
}
