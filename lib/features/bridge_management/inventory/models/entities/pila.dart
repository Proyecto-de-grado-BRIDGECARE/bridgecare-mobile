class Pila {
  final int? id;
  final int tipo;
  final int material;
  final int tipoCimentacion;
  final int subestructuraId;

  Pila({
    this.id,
    required this.tipo,
    required this.material,
    required this.tipoCimentacion,
    required this.subestructuraId,
  });

  static const Map<String, dynamic> formFields = {
    'tipo': {
      'type': 'dropdown',
      'label': 'Tipo',
      'options': [
        '10 - Pila sólida',
        '20 - Columna sola',
        '21 - 2 ó más columnas sin viga cabezal',
        '30 - Columna sola con viga cabezal',
        '31 - 2 ó más columnas con vigas cabezales separadas',
        '32 - 2 ó más columnas con viga cabezal común',
        '33 - 2 ó más columnas con viga cabezal común y diafragma',
        '40 - Pilotes con viga cabezal',
        '41 - Pilotes con viga cabezal y diafragma',
        '50 - Mástil (Pilón)',
        '60 - Torre metálica',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'material': {
      'type': 'dropdown',
      'label': 'Material',
      'options': [
        '10 - Mampostería',
        '20 - Concreto ciclópeo',
        '21 - Concreto reforzado',
        '30 - Acero',
        '40 - Acero y concreto',
        '50 - Tierra armada',
        '60 - Ladrillo',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'tipoCimentacion': {
      'type': 'dropdown',
      'label': 'Tipo de Cimentación',
      'options': [
        '10 - Cimentación superficial',
        '20 - Pilotes de concreto',
        '21 - Pilotes de acero',
        '22 - Pilotes de madera',
        '30 - Caisson de concreto',
        '40 - Cajón de autofundante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
  };
}
