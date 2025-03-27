class Usuario {
  final int id;
  final String nombres;
  final String apellidos;
  final int identificacion;
  final int tipoUsuario;
  final String correo;
  final String? municipio;
  final String? contrasenia;

  Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.identificacion,
    required this.tipoUsuario,
    required this.correo,
    this.municipio,
    this.contrasenia,
  });

  // JSON Serialisation
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nombres: json['nombres'] ?? '', // Default to empty string if null
      apellidos: json['apellidos'] ?? '',
      identificacion:
          json['identificacion'] != null ? json['identificacion'] as int : 0,
      tipoUsuario:
          json['tipo_usuario'] != null ? json['tipo_usuario'] as int : 0,
      correo: json['correo'] ?? '',
      municipio:
          json['municipio'] as String?, // Allow null values for nullable fields
      contrasenia: json['contrasenia']
          as String?, // Allow null values for nullable fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'identificacion': identificacion,
      'tipo_usuario': tipoUsuario,
      'correo': correo,
      if (municipio != null) 'municipio': municipio,
      if (contrasenia != null) 'contrasenia': contrasenia,
    };
  }
}
