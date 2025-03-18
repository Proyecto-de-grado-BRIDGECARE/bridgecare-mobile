import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bridgecare/features/user_management/models/usuario.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();

  // Mapa basado en el modelo Usuario
  Map<String, dynamic> _formData = {
    "id": 0, // Se genera en la API
    "nombres": "",
    "apellidos": "",
    "identificacion": "",
    "tipoUsuario": 2, // Tipo de usuario fijo (Ej: 2 = Usuario)
    "correo": "",
    "municipio": "",
    "contrasenia": "",
  };

  Future<void> _enviarDatos() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save(); // Guarda los valores en _formData

    try {
      final response = await http.post(
        Uri.parse("https://tu-api.com/usuarios"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario registrado con éxito")),
        );
        Navigator.pop(context); // Regresa a la pantalla anterior
      } else {
        throw Exception('Error al registrar usuario: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: AppBar(
        title: Text(
          "Registro de Usuario",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFFEBEBEB),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF111D2C),
                  ),
                  child: Text(
                    "REGISTRAR",
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
    String key, {
    bool isPassword = false,
    bool isEmail = false,
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isNumeric
                ? TextInputType.number
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
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
}
