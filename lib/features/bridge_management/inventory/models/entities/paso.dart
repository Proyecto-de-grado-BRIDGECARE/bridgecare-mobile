class Paso {
  final int? id;
  final int numero; // Auto-set to 1 or 2
  final String tipoPaso;
  final bool primero;
  final String supInf;
  double? galiboI;
  double? galiboIm;
  double? galiboDm;
  double? galiboD;
  final int inventarioId;

  Paso({
    this.id,
    required this.numero,
    required this.tipoPaso,
    required this.primero,
    required this.supInf,
    this.galiboI,
    this.galiboIm,
    this.galiboDm,
    this.galiboD,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    // 'numero' omitted from form; auto-set to 1 or 2 based on context
    'tipoPaso': {
      'type': 'dropdown',
      'label': 'Tipo de Paso',
      'options': ['S', 'I'],
    },
    'primero': {
      'type': 'dropdown',
      'label': 'Primero',
      'options': ['Sí', 'No'],
    },
    'supInf': {
      'type': 'dropdown',
      'label': 'Superior/Inferior',
      'options': ['S', 'I'],
    },
    'galiboI': {
      'type': 'number',
      'label': 'Galibo I (m)',
    },
    'galiboIm': {
      'type': 'number',
      'label': 'Galibo IM (m)',
    },
    'galiboDm': {
      'type': 'number',
      'label': 'Galibo DM (m)',
    },
    'galiboD': {
      'type': 'number',
      'label': 'Galibo D (m)',
    },
  };
}
