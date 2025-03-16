class Estribo {
  final int? id;
  final int tipo;
  final int material;
  final int tipoCimentacion;
  final int subestructuraId;

  Estribo({
    this.id,
    required this.tipo,
    required this.material,
    required this.tipoCimentacion,
    required this.subestructuraId,
  });

  static const Map<String, dynamic> formFields = {
    'tipo': {'type': 'number', 'label': 'Tipo'},
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
