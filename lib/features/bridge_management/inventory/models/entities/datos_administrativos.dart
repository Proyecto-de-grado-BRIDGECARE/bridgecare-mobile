class DatosAdministrativos {
  final int? id;
  final int anioConstruccion;
  final int anioReconstruccion;
  final String direccionAbscCarretera;
  final String requisitosInspeccion;
  final String numeroSeccionesInspeccion;
  final String estacionConteo;
  final DateTime fechaRecoleccionDatos;
  final int inventarioId;

  DatosAdministrativos({
    this.id,
    required this.anioConstruccion,
    required this.anioReconstruccion,
    required this.direccionAbscCarretera,
    required this.requisitosInspeccion,
    required this.numeroSeccionesInspeccion,
    required this.estacionConteo,
    required this.fechaRecoleccionDatos,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    'anioConstruccion': {'type': 'number', 'label': 'Año de Construcción'},
    'anioReconstruccion': {'type': 'number', 'label': 'Año de Reconstrucción'},
    'direccionAbscCarretera': {
      'type': 'dropdown',
      'label': 'Dirección Abscisa Carretera (N/S/E/O)',
      'options': ['N', 'S', 'E', 'O'],
    },
    'requisitosInspeccion': {
      'type': 'text',
      'label': 'Requisitos de Inspección'
    },
    'numeroSeccionesInspeccion': {
      'type': 'text',
      'label': 'Número de Secciones Inspección'
    },
    'estacionConteo': {'type': 'text', 'label': 'Estación de Conteo'},
    'fechaRecoleccionDatos': {
      'type': 'date',
      'label': 'Fecha de Recolección de Datos'
    },
  };
}
