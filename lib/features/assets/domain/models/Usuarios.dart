class Usuario {
<<<<<<< HEAD
  final String nombre;
  final String apellidos;
  final String identificacion;
=======
  final String id;
  final String nombre;
  final String apellidos;
  final String noId;
>>>>>>> listaUsuarios
  final String tipoUsuario;
  final String correo;
  final String municipio;
  final String contrasenia;

  Usuario({
<<<<<<< HEAD
    required this.nombre,
    required this.apellidos,
    required this.identificacion,
=======
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.noId,
>>>>>>> listaUsuarios
    required this.tipoUsuario,
    required this.correo,
    required this.municipio,
    required this.contrasenia,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
<<<<<<< HEAD
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      identificacion: json['identificacion'],
=======
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      noId: json['noId'],
>>>>>>> listaUsuarios
      tipoUsuario: json['tipoUsuario'],
      correo: json['correo'],
      municipio: json['municipio'],
      contrasenia: json['contrasenia'],
    );
  }
}
