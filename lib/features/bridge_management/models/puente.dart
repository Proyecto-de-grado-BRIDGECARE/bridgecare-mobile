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
    'nombre': {'type': 'text', 'label': 'Nombre', 'required': true},
    'identif': {'type': 'text', 'label': 'Identificador', 'required': true},
    'carretera': {'type': 'number', 'label': 'Carretera', 'maxLength': 10, // Max 10 digits enforced in UI
      'required': true},
    'pr': {'type': 'text', 'label': 'PR', 'required': true},
    'regional': {'type': 'text', 'label': 'Regional', 'required': true},
  };

  factory Puente.fromJson(Map<String, dynamic> json) {
    return Puente(
        id: json['id'],
        identif: json['identif'],
        nombre: json['nombre'],
        carretera: json['carretera'],
        pr: json['pr'],
        regional: json['regional']);
  }
}
