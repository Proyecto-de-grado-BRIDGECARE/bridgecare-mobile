class Carga {
  final int? id;
  final double longitudLuzCritica;
  final String factorClasificacion;
  final String fuerzaCortante;
  final String momento;
  final String lineaCargaPorRueda;
  final int inventarioId;

  Carga({
    this.id,
    required this.longitudLuzCritica,
    required this.factorClasificacion,
    required this.fuerzaCortante,
    required this.momento,
    required this.lineaCargaPorRueda,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    'longitudLuzCritica': {
      'type': 'number',
      'label': 'Longitud Luz Crítica (m)'
    },
    'factorClasificacion': {'type': 'text', 'label': 'Factor de Clasificación'},
    'fuerzaCortante': {'type': 'text', 'label': 'Fuerza Cortante (t)'},
    'momento': {'type': 'text', 'label': 'Momento (t.m)'},
    'lineaCargaPorRueda': {
      'type': 'text',
      'label': 'Línea de Carga por Rueda (t)'
    },
  };
}
