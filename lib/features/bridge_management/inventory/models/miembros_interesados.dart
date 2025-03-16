class MiembrosInteresados {
  final int? id;
  final String propietario;
  final String departamento;
  final String administradorVial;
  final String proyectista;
  final String municipio;
  final int inventarioId;

  MiembrosInteresados({
    this.id,
    required this.propietario,
    required this.departamento,
    required this.administradorVial,
    required this.proyectista,
    required this.municipio,
    required this.inventarioId,
  });

  static const Map<String, dynamic> formFields = {
    'propietario': {'type': 'text', 'label': 'Propietario'},
    'departamento': {'type': 'text', 'label': 'Departamento'},
    'administradorVial': {'type': 'text', 'label': 'Administrador Vial'},
    'proyectista': {'type': 'text', 'label': 'Proyectista'},
    'municipio': {'type': 'text', 'label': 'Municipio'},
  };
}
