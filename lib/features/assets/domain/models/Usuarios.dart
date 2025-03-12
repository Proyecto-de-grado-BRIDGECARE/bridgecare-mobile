class Usuario {
  final String nombre;
  final String apellidos;
  final String identificacion;
  final String tipoUsuario;
  final String correo;
  final String municipio;
  final String contrasenia;

  Usuario({
    required this.nombre,
    required this.apellidos,
    required this.identificacion,
    required this.tipoUsuario,
    required this.correo,
    required this.municipio,
    required this.contrasenia,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      identificacion: json['identificacion'],
      tipoUsuario: json['tipoUsuario'],
      correo: json['correo'],
      municipio: json['municipio'],
      contrasenia: json['contrasenia'],
    );
  }
}
