class DatosTecnicos {
  final int? id;
  final int numeroLuces;
  final double longitudLuzMenor;
  final double longitudLuzMayor;
  final double longitudTotal;
  final double anchoTablero;
  final double anchoSeparador;
  final double anchoAndenIzq;
  final double anchoAndenDer;
  final double anchoCalzada;
  final double anchoEntreBordillos;
  final double anchoAcceso;
  final double alturaPilas;
  final double alturaEstribos;
  final double longitudApoyoPilas;
  final double longitudApoyoEstribos;
  final bool puenteTerraplen;
  final String puenteCurvaTangente;
  final double esviajamiento;
  final int inventarioId;

  DatosTecnicos({
    this.id,
    required this.numeroLuces,
    required this.longitudLuzMenor,
    required this.longitudLuzMayor,
    required this.longitudTotal,
    required this.anchoTablero,
    required this.anchoSeparador,
    required this.anchoAndenIzq,
    required this.anchoAndenDer,
    required this.anchoCalzada,
    required this.anchoEntreBordillos,
    required this.anchoAcceso,
    required this.alturaPilas,
    required this.alturaEstribos,
    required this.longitudApoyoPilas,
    required this.longitudApoyoEstribos,
    required this.puenteTerraplen,
    required this.puenteCurvaTangente,
    required this.esviajamiento,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    'numeroLuces': {'type': 'number', 'label': 'Número de luces'},
    'longitudLuzMenor': {'type': 'number', 'label': 'Longitud Luz Menor (m)'},
    'longitudLuzMayor': {'type': 'number', 'label': 'Longitud Luz Mayor (m)'},
    'longitudTotal': {'type': 'number', 'label': 'Longitud Total (m)'},
    'anchoTablero': {'type': 'number', 'label': 'Ancho Tablero (m)'},
    'anchoSeparador': {'type': 'number', 'label': 'Ancho Separador (m)'},
    'anchoAndenIzq': {'type': 'number', 'label': 'Ancho Andén Izquierdo (m)'},
    'anchoAndenDer': {'type': 'number', 'label': 'Ancho Andén Derecho (m)'},
    'anchoCalzada': {'type': 'number', 'label': 'Ancho Calzada (m)'},
    'anchoEntreBordillos': {
      'type': 'number',
      'label': 'Ancho Entre Bordillos (m)'
    },
    'anchoAcceso': {'type': 'number', 'label': 'Ancho Acceso (m)'},
    'alturaPilas': {'type': 'number', 'label': 'Altura Pilas (m)'},
    'alturaEstribos': {'type': 'number', 'label': 'Altura Estribos (m)'},
    'longitudApoyoPilas': {
      'type': 'number',
      'label': 'Longitud de Apoyo en Pilas (m)'
    },
    'longitudApoyoEstribos': {
      'type': 'number',
      'label': 'Longitud Apoyo Estribos'
    },
    'puenteTerraplen': {
      'type': 'dropdown',
      'label': 'Puente Terraplén',
      'options': ['Sí', 'No'],
    },
    'puenteCurvaTangente': {
      'type': 'dropdown',
      'label': 'Puente Curva/Tangente',
      'options': ['C', 'T'],
    },
    'esviajamiento': {'type': 'number', 'label': 'Esviajamiento (gra)'},
  };
}
