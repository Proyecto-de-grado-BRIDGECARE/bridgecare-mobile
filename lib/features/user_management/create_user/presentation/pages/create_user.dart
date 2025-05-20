import 'package:bridgecare/features/user_management/models/usuario.dart';
import 'package:bridgecare/features/user_management/services/usuario_service.dart';
import 'package:flutter/material.dart';

import '../../../../administrador/presentation/list_user_admin.dart';

class RegistroUsuario extends StatefulWidget {
  final Usuario? usuario;
  const RegistroUsuario({super.key, this.usuario});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _formData = {
    "id": null,
    "nombres": "",
    "apellidos": "",
    "identificacion": "",
    "tipoUsuario": 2,
    "correo": "",
    "municipio": "",
    "contrasenia": "",
  };

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _formData = {
        "id": widget.usuario!.id,
        "nombres": widget.usuario!.nombres,
        "apellidos": widget.usuario!.apellidos,
        "identificacion": widget.usuario!.identificacion,
        "tipoUsuario": widget.usuario!.tipoUsuario,
        "correo": widget.usuario!.correo,
        "municipio": widget.usuario!.municipio,
        "contrasenia": "", // no mostrar contraseñas en edición
      };
    }
  }

  Future<void> _enviarDatos() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final usuario = Usuario(
      id: _formData["id"],
      nombres: _formData["nombres"],
      apellidos: _formData["apellidos"],
      identificacion: _formData["identificacion"],
      tipoUsuario: _formData["tipoUsuario"],
      correo: _formData["correo"],
      municipio: _formData["municipio"],
      contrasenia:
          _formData["contrasenia"] == "" ? null : _formData["contrasenia"],
    );

    try {
      if (widget.usuario != null) {
        await UserService()
            .updateUsuario(usuario); // deberías tener este método
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario actualizado con éxito")),
          );
        }
      } else {
        await UserService().registerUsuario(usuario);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario registrado con éxito")),
          );
        }
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/homeAdmin');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff281537),
                  Color(0xff3ab4fb),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 22),
              child: Text(
                widget.usuario != null ? 'Editar usuario' : 'Crear usuario',
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Formulario en tarjeta blanca redondeada
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField("Nombres", "nombres"),
                      _buildTextField("Apellidos", "apellidos"),
                      _buildTextField(
                          "Número de Identificación", "identificacion",
                          isNumeric: true),
                      _buildTextField("Correo Electrónico", "correo",
                          isEmail: true),
                      _buildTextField("Municipio", "municipio"),
                      _buildTextField("Contraseña", "contrasenia",
                          isPassword: true),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: _formData["tipoUsuario"],
                        decoration: const InputDecoration(
                          label: Text(
                            'Tipo de Usuario',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff281537),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff3ab4fb)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff281537)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Estudiante')),
                          DropdownMenuItem(value: 0, child: Text('Municipal')),
                          DropdownMenuItem(
                              value: 2, child: Text('Administrador')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _formData["tipoUsuario"] = value ?? 2;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Seleccione un tipo de usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: _enviarDatos,
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff3ab4fb),
                                Color(0xff281537),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.usuario != null ? 'EDITAR' : 'REGISTRAR',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.usuario == null) ...[

                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/homeAdmin');
                                },
                                child: const Text(
                                  "← Volver",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ] else ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UsuariosListAdminScreen()),
                                  );
                                },
                                child: const Text(
                                  "← Volver a la lista de usuarios",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String key, {
    bool isPassword = false,
    bool isEmail = false,
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: _formData[key]?.toString() ?? "",
        obscureText: isPassword,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isNumeric
                ? TextInputType.number
                : TextInputType.text,
        style: const TextStyle(
          color: Color(0xff27252b),
        ),
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_off, color: Colors.grey)
              : const Icon(Icons.check, color: Colors.grey),
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff281537),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff3ab4fb)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff281537)),
          ),
        ),
        validator: (value) {
          if (key == "contrasenia") {
            // Si es modo registro, la contraseña es obligatoria
            if (widget.usuario == null && (value == null || value.isEmpty)) {
              return "Por favor, ingrese $label";
            }
            // Si es modo edición y la deja vacía, es válido (no se cambiará)
            return null;
          }

          if (value == null || value.isEmpty) {
            return "Por favor, ingrese $label";
          }
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "Ingrese un correo válido";
          }
          if (isNumeric && int.tryParse(value) == null) {
            return "Ingrese un número válido";
          }
          return null;
        },
        onSaved: (value) {
          if (isNumeric) {
            _formData[key] = int.tryParse(value!) ?? 0;
          } else {
            _formData[key] = value;
          }
        },
      ),
    );
  }

  /*
  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<int>(
        value: _formData["tipoUsuario"],
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        decoration: const InputDecoration(
          label: Text(
            'Tipo de Usuario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff281537),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior
              .always, // 🔥 mantiene el label siempre arriba
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff3ab4fb)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff281537)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          isDense: true, // 🔥 ayuda a mantener altura similar al TextFormField
        ),
        items: const [
          DropdownMenuItem(value: 1, child: Text('Estudiante')),
          DropdownMenuItem(value: 0, child: Text('Municipal')),
          DropdownMenuItem(value: 2, child: Text('Administrador')),
        ],
        onChanged: (value) {
          setState(() {
            _formData["tipoUsuario"] = value ?? 2;
          });
        },
        validator: (value) {
          if (value == null) return 'Seleccione un tipo de usuario';
          return null;
        },
      ),
    );
  }
  */
}
