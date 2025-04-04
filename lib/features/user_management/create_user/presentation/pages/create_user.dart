import 'dart:convert';
import 'package:bridgecare/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    "id": 0,
    "nombres": "",
    "apellidos": "",
    "identificacion": "",
    "tipoUsuario": 2,
    "correo": "",
    "municipio": "",
    "contrasenia": "",
  };

  Future<void> _enviarDatos() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      final response = await http.post(
        Uri.parse("https://tu-api.com/usuarios"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario registrado con éxito")),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception('Error al registrar usuario: ${response.body}');
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
            child: const Padding(
              padding: EdgeInsets.only(top: 70.0, left: 22),
              child: Text(
                'Crea tu cuenta',
                style: TextStyle(
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
                          child: const Center(
                            child: Text(
                              'REGISTRAR',
                              style: TextStyle(
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
                            const Text(
                              "¿Ya tienes una cuenta?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: const Text(
                                "Inicia sesión",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
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
        obscureText: isPassword,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isNumeric
                ? TextInputType.number
                : TextInputType.text,
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
