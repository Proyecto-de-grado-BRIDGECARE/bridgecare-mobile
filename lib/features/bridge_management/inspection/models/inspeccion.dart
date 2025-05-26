class Inspeccion {
  final int? id;
  final int tiempo;
  final int temperatura;
  final String administrador;
  final int anioProximaInspeccion;
  final String? observacionesGenerales;
  final DateTime fecha;


  Inspeccion({
    this.id,
    required this.tiempo,
    required this.temperatura,
    required this.administrador,
    required this.anioProximaInspeccion,
    this.observacionesGenerales,
    required this.fecha,
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

  Map<String, dynamic> toJson({required int puenteId, required int usuarioId}) {
    return {
      if (id != null) 'id': id,
      'tiempo': tiempo,
      'temperatura': temperatura,
      'administrador': administrador,
      'anioProximaInspeccion': anioProximaInspeccion,
      'observacionesGenerales': observacionesGenerales,
      'fecha': fecha.toIso8601String(),
      'puente': {
        'id': puenteId,
      },
      'usuario': {
        'id': usuarioId,
      },
    };
  }


}
