import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  // final _formKey = GlobalKey<FormState>();

  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController noId = TextEditingController();
  TextEditingController tipoUsuario = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController municipio = TextEditingController();
  TextEditingController consrtasenia = TextEditingController();

  Future<void> _enviarDatos() async {
    final url = Uri.parse("https://tu-api.com/usuarios");

    final Map<String, dynamic> usuarioData = {
      "nombre": nombre.text,
      "apellidos": apellidos.text,
      "identificacion": noId.text,
      "tipoUsuario": tipoUsuario.text,
      "correo": correo.text,
      "municipio": municipio.text,
      "contrasena": consrtasenia.text,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(usuarioData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Usuario registrado con éxito")));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
            SnackBar(content: Text("Error al registrar el usuario")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        title: Text(
          "Registro de usuarios",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFFEBEBEB),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Card(
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        _buildTextField("Nombre", nombre),
                        _buildTextField("Apellidos", apellidos),
                        _buildTextField("Número de Identificación", noId),
                        _buildTextField("Tipo de Usuario", tipoUsuario),
                        _buildTextField(
                          "Correo Electrónico",
                          correo,
                          isEmail: true,
                        ),
                        _buildTextField("Municipio", municipio),
                        _buildTextField(
                          "Contraseña",
                          consrtasenia,
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x00111d2c),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: _enviarDatos,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(0xFF111D2C), // Color del botón
                  ),
                  child: Text(
                    "ACTUALIZAR",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, ingrese $label";
          }
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "Ingrese un correo válido";
          }
          return null;
        },
      ),
    );
  }
}
