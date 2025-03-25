class PosicionGeografica {
  final int? id;
  final double latitud;
  final double longitud;
  final double altitud;
  final String coeficienteAceleracionSismica;
  final bool pasoCauce;
  final bool existeVariante;
  final double longitudVariante;
  final String estado;
  final int inventarioId;

  PosicionGeografica({
    this.id,
    required this.latitud,
    required this.longitud,
    required this.altitud,
    required this.coeficienteAceleracionSismica,
    required this.pasoCauce,
    required this.existeVariante,
    required this.longitudVariante,
    required this.estado,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    'latitud': {'type': 'number', 'label': 'Latitud (N)'},
    'longitud': {'type': 'number', 'label': 'Longitud (O)'},
    'altitud': {'type': 'number', 'label': 'Altitud (m)'},
    'coeficienteAceleracionSismica': {
      'type': 'text',
      'label': 'Coeficiente Aceleración Sísmica (Aa)'
    },
    'pasoCauce': {
      'type': 'dropdown',
      'label': 'Paso Cauce',
      'options': ['Sí', 'No'],
    },
    'existeVariante': {
      'type': 'dropdown',
      'label': 'Existe Variante',
      'options': ['Sí', 'No'],
    },
    'longitudVariante': {'type': 'number', 'label': 'Longitud Variante'},
    'estado': {
      'type': 'dropdown',
      'label': 'Estado',
      'options': ['B', 'R', 'M'],
    },
  };
}
