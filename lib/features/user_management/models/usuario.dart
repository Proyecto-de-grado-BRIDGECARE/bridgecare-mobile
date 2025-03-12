class Usuario {
  final String id;
  final String nombre;
  final String apellidos;
  final String noId;
  final String tipoUsuario;
  final String correo;
  final String municipio;
  final String contrasenia;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.noId,
    required this.tipoUsuario,
    required this.correo,
    required this.municipio,
    required this.contrasenia,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      noId: json['noId'],
      tipoUsuario: json['tipoUsuario'],
      correo: json['correo'],
      municipio: json['municipio'],
      contrasenia: json['contrasenia'],
    );
  }
}
