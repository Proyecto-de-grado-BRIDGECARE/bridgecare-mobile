class Apoyo {
  final int? id;
  final int fijoSobreEstribo;
  final int movilSobreEstribo;
  final int fijoEnPila;
  final int movilEnPila;
  final int fijoEnViga;
  final int movilEnViga;
  final int vehiculoDiseno;
  final int claseDistribucionCarga;
  final int inventarioId;

  Apoyo({
    this.id,
    required this.fijoSobreEstribo,
    required this.movilSobreEstribo,
    required this.fijoEnPila,
    required this.movilEnPila,
    required this.fijoEnViga,
    required this.movilEnViga,
    required this.vehiculoDiseno,
    required this.claseDistribucionCarga,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    'fijoSobreEstribo': {
      'type': 'dropdown',
      'label': 'Fijo Sobre Estribo',
      'options': [
        '10 - Junta de construcción (acaso con una capa de cartón asfaltado ó de plomo)',
        '20 - Balancín de concreto',
        '30 - Placas de neopreno',
        '40 - Apoyo fijo de acero',
        '41 - Apoyo de deslizamiento (acero)',
        '42 - Balancín de acero',
        '43 - Apoyos de rodillos (acero)',
        '50 - Basculante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'movilSobreEstribo': {
      'type': 'dropdown',
      'label': 'Móvil Sobre Estribo',
      'options': [
        '10 - Junta de construcción (acaso con una capa de cartón asfaltado ó de plomo)',
        '20 - Balancín de concreto',
        '30 - Placas de neopreno',
        '40 - Apoyo fijo de acero',
        '41 - Apoyo de deslizamiento (acero)',
        '42 - Balancín de acero',
        '43 - Apoyos de rodillos (acero)',
        '50 - Basculante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'fijoEnPila': {
      'type': 'dropdown',
      'label': 'Fijo en Pila',
      'options': [
        '10 - Junta de construcción (acaso con una capa de cartón asfaltado ó de plomo)',
        '20 - Balancín de concreto',
        '30 - Placas de neopreno',
        '40 - Apoyo fijo de acero',
        '41 - Apoyo de deslizamiento (acero)',
        '42 - Balancín de acero',
        '43 - Apoyos de rodillos (acero)',
        '50 - Basculante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'movilEnPila': {
      'type': 'dropdown',
      'label': 'Móvil en Pila',
      'options': [
        '10 - Junta de construcción (acaso con una capa de cartón asfaltado ó de plomo)',
        '20 - Balancín de concreto',
        '30 - Placas de neopreno',
        '40 - Apoyo fijo de acero',
        '41 - Apoyo de deslizamiento (acero)',
        '42 - Balancín de acero',
        '43 - Apoyos de rodillos (acero)',
        '50 - Basculante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'fijoEnViga': {
      'type': 'dropdown',
      'label': 'Fijo en Viga',
      'options': [
        '10 - Junta de construcción (acaso con una capa de cartón asfaltado ó de plomo)',
        '20 - Balancín de concreto',
        '30 - Placas de neopreno',
        '40 - Apoyo fijo de acero',
        '41 - Apoyo de deslizamiento (acero)',
        '42 - Balancín de acero',
        '43 - Apoyos de rodillos (acero)',
        '50 - Basculante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'movilEnViga': {
      'type': 'dropdown',
      'label': 'Móvil en Viga',
      'options': [
        '10 - Junta de construcción (acaso con una capa de cartón asfaltado ó de plomo)',
        '20 - Balancín de concreto',
        '30 - Placas de neopreno',
        '40 - Apoyo fijo de acero',
        '41 - Apoyo de deslizamiento (acero)',
        '42 - Balancín de acero',
        '43 - Apoyos de rodillos (acero)',
        '50 - Basculante',
        '90 - Otro',
        '91 - No aplicable',
        '92 - Desconocido',
        '93 - No registrado',
      ],
    },
    'vehiculoDiseno': {'type': 'number', 'label': 'Vehículo de Diseño'},
    'claseDistribucionCarga': {
      'type': 'dropdown',
      'label': 'Clase Distribución Carga',
      'options': [
        '1 - Distribución en dos direcciones',
        '2 - Distribución en una dirección',
        '3 - No distribución',
      ],
    },
  };
}
