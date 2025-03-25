class Superestructura {
  final int? id;
  final int tipo; // Auto-set to 1 (Principal) or 2 (Secundario)
  final bool disenioTipo;
  final int tipoEstructuracionTransversal;
  final int tipoEstructuracionLongitudinal;
  final int material;
  final int inventarioId;

  Superestructura({
    this.id,
    required this.tipo,
    required this.disenioTipo,
    required this.tipoEstructuracionTransversal,
    required this.tipoEstructuracionLongitudinal,
    required this.material,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    // 'tipo' omitted from form; auto-set to 1 or 2 based on context
    'disenioTipo': {
      'type': 'dropdown',
      'label': 'Diseño Tipo',
      'options': ['Sí', 'No'],
    },
    'tipoEstructuracionTransversal': {
      'type': 'dropdown',
      'label': 'Tipo Estructuración Transversal',
      'options': [
        '10 - Losa',
        '11 - Losa/viga, 1 viga',
        '12 - Losa/viga, 2 vigas',
        '13 - Losa/viga, 3 vigas',
        '14 - Losa/viga, 4 ó más vigas',
        '30 - Viga cajón, 1 cajón',
        '31 - Viga cajón, 2 ó más cajones',
        '40 - Armadura de paso inferior',
        '41 - Armadura de paso superior',
        '42 - Armadura de paso a través',
        '50 - Arco superior',
        '51 - Arco inferior, tipo abierto',
        '52 - Arco inferior, tipo cerrado',
        '80 - Provisional, tipo Bailey',
        '81 - Provisional, tipo Callender Hamilton',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'tipoEstructuracionLongitudinal': {
      'type': 'dropdown',
      'label': 'Tipo Estructuración Longitudinal',
      'options': [
        '10 - Losa',
        '11 - Losa/viga, 1 viga',
        '12 - Losa/viga, 2 vigas',
        '13 - Losa/viga, 3 vigas',
        '14 - Losa/viga, 4 ó más vigas',
        '30 - Viga cajón, 1 cajón',
        '31 - Viga cajón, 2 ó más cajones',
        '40 - Armadura de paso inferior',
        '41 - Armadura de paso superior',
        '42 - Armadura de paso a través',
        '50 - Arco superior',
        '51 - Arco inferior, tipo abierto',
        '52 - Arco inferior, tipo cerrado',
        '80 - Provisional, tipo Bailey',
        '81 - Provisional, tipo Callender Hamilton',
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
        '10 - Concreto ciclópeo',
        '11 - Concreto simple',
        '20 - Concreto reforzado, in situ',
        '21 - Concreto reforzado, prefabricado',
        '30 - Concreto presforzado, in situ',
        '31 - Concreto presforzado, prefabricado',
        '32 - Concreto presforzado, en secciones',
        '41 - Concreto presforzado prefabricado & in situ',
        '42 - Concreto y acero',
        '50 - Acero',
        '60 - Mampostería',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
  };
}
