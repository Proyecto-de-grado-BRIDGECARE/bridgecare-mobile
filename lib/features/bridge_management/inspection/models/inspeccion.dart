class Inspeccion {
  final int? id;
  final int tiempo;
  final int temperatura;
  final String administrador;
  final int anioProximaInspeccion;
  final String observacionesGenerales;
  final int puenteId;
  final int usuarioId;
  final DateTime fecha;

  Inspeccion({
    this.id,
    required this.tiempo,
    required this.temperatura,
    required this.administrador,
    required this.anioProximaInspeccion,
    required this.observacionesGenerales,
    required this.fecha,
    required this.puenteId,
    required this.usuarioId,
  });

  static const Map<String, dynamic> formFields = {
    'tiempo': {'type': 'number', 'label': 'Tiempo'},
    'temperatura': {'type': 'number', 'label': 'Temperatura'},
    'administrador': {'type': 'text', 'label': 'Administrador'},
    'anioProximaInspeccion': {
      'type': 'number',
      'label': 'Año Próxima Inspección'
    },
    'fecha': {'type': 'date', 'label': 'Fecha'},
  };
}
