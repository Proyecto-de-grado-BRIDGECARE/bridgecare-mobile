class Detalle {
  final int? id;
  final int tipoBaranda;
  final int superficieRodadura;
  final int juntaExpansion;
  final int subestructuraId;

  Detalle({
    this.id,
    required this.tipoBaranda,
    required this.superficieRodadura,
    required this.juntaExpansion,
    required this.subestructuraId,
  });

  static const Map<String, dynamic> formFields = {
    'tipoBaranda': {
      'type': 'dropdown',
      'label': 'Tipo de Baranda',
      'options': [
        '10 - Sólida, mampostería',
        '20 - Sólida, concreto',
        '21 - Sólida, concreto, con pasamanos metálicas',
        '30 - Pasamanos de concreto y pilastras de concreto',
        '40 - Pasamanos metálicas y pilastras de concreto',
        '41 - Pasamanos metálicas y pilastras metálicas',
        '50 - Construcción metálica ligera',
        '60 - Parte integral de la superestructura',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'superficieRodadura': {
      'type': 'dropdown',
      'label': 'Superficie de Rodadura',
      'options': [
        '10 - Asfalto',
        '20 - Concreto',
        '30 - Acero (con dispositivo de fricción)',
        '40 - Afirmado',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'juntaExpansion': {
      'type': 'dropdown',
      'label': 'Junta de Expansión',
      'options': [
        '10 - Placa de acero',
        '11 - Placa de acero cubierta de asfalto',
        '12 - Placas verticales / ángulos de acero',
        '13 - Junta dentada',
        '20 - Acero con sello fijo de neopreno',
        '21 - Acero con neopreno comprimido',
        '30 - Bloque de neopreno',
        '40 - Junta de goma asfáltica',
        '50 - No dispositivo de junta',
        '51 - Junta de cartón asfaltado',
        '52 - Junta de cartón asfaltado con sello',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
  };
}
