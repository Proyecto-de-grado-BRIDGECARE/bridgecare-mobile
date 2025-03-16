class Puente {
  final int? id;
  final String nombre;
  final String identif;
  final String carretera;
  final String pr;
  final String regional;

  Puente({
    this.id,
    required this.nombre,
    required this.identif,
    required this.carretera,
    required this.pr,
    required this.regional,
  });

  static const Map<String, dynamic> formFields = {
    'nombre': {'type': 'text', 'label': 'Nombre'},
    'identif': {'type': 'text', 'label': 'Identificador'},
    'carretera': {
      'type': 'number',
      'label': 'Carretera',
      'maxLength': 10, // Max 10 digits enforced in UI
    },
    'pr': {'type': 'text', 'label': 'PR'},
    'regional': {
      'type': 'dropdown',
      'label': 'Regional',
      'options': [
        '1 - Antioquia',
        '2 - Atlántico',
        '3 - Bolívar',
        '4 - Boyacá',
        '5 - Caldas',
        '6 - Caquetá',
        '7 - Casanare',
        '8 - Cauca',
        '9 - Cesar',
        '10 - Chocó',
        '11 - Córdoba',
        '12 - Cundinamarca',
        '13 - La Guajira',
        '14 - Huila',
        '15 - Magdalena',
        '16 - Meta',
        '17 - Nariño',
        '18 - Norte de Santander',
        '19 - Putumayo',
        '20 - Quindío',
        '21 - Risaralda',
        '22 - Santander',
        '23 - Sucre',
        '24 - Tolima',
        '25 - Valle del Cauca',
        '26 - Ocaña',
      ],
    },
  };
}
