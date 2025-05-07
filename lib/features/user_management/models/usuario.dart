class Usuario {
  final int? id;
  final String nombres;
  final String apellidos;
  final int identificacion;
  final int tipoUsuario;
  final String correo;
  final String? municipio;
  final String? contrasenia;

  Usuario({
    this.id,
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
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      identificacion: json['identificacion'] as int,
      tipoUsuario: json['tipo_usuario'] as int,
      correo: json['correo'] as String,
      municipio: json['municipio'] as String?,
      contrasenia: json['contrasenia'] as String?,
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
