class Componente {
  final int? id;
  final String nombre;
  final int calificacion;
  final String mantenimiento;
  final String inspEsp;
  final int numeroFotos;
  final int tipoDanio;
  final String danio;
  final List<String>? imagenUrls;
  final int inspeccionId;

  Componente({
    this.id,
    required this.nombre,
    required this.calificacion,
    required this.mantenimiento,
    required this.inspEsp,
    required this.numeroFotos,
    required this.tipoDanio,
    required this.danio,
    required this.inspeccionId,
    this.imagenUrls,
  });

  static const Map<String, dynamic> formFields = {
    'calificacion': {
      'type': 'dropdown',
      'label': 'Calificación',
      'options': [
        '0 - Sin daño o daño insignificante',
        '1 - Daño pequeño pero no es necesaria reparación (excepto mantenimiento menor)',
        '2 - Algún daño, reparación necesaria cuando se presente la ocasión. El componente funciona como se diseñó',
        '3 - Daño significativo, reparación necesaria muy pronto',
        '4 - Daño grave, reparación necesaria inmediatamente',
        '5 - Daño extremo, falla total o riesgo de falla total del componente',
        '? - Desconocido',
      ],
    },
    'mantenimiento': {'type': 'text', 'label': 'Mantenimiento'},
    'inspEsp': {'type': 'text', 'label': 'Inspección Especial'},
    'numeroFotos': {'type': 'number', 'label': 'Número de Fotos'},
    'tipoDanio': {
      'type': 'dropdown',
      'label': 'Tipo de Daño',
      'options': [
        '10 - Daño estructural (Sobrecarga / diseño insuficiente)',
        '15 - Vibración excesiva',
        '20 - Impacto',
        '30 - Asentamiento / Movimiento',
        '40 - Erosión / Socavación',
        '50 - Corrosión de acero estructural',
        '55 - Faltan remaches y/o pernos',
        '60 - Daño en concreto / Corrosión de reforzamiento',
        '65 - Daño en concreto / Acero expuesto',
        '70 - Descomposición',
        '80 - Infiltración',
      ],
    },
    'danio': {'type': 'text', 'label': 'Daño'},
    'imagen': {
      'type': 'image',
      'label': 'Imágenes (0-5)',
      'maxImages': 5,
    },
  };
}
