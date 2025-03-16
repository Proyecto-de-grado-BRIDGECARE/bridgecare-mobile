import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetallesUsuario extends StatelessWidget {
  final Map<String, String> user;

  const DetallesUsuario({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles de Usuario")),
      body: Container(
        color: Color(0xFFC6C5C5), // Color de fondo
        padding: EdgeInsets.all(16), // Espaciado alrededor del card
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(20), // Espaciado dentro del card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Nombre"),
                _buildValue(user["name"]!),
                SizedBox(height: 16),

                _buildLabel("Correo"),
                _buildValue(user["email"]!),
                SizedBox(height: 16),

                _buildLabel("Fecha de solicitud"),
                _buildValue(user["date"]!),
                SizedBox(height: 20),

                // Dropdown para seleccionar el rol
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Rol",
                    border: OutlineInputBorder(),
                  ),
                  items: ["Administrador", "Usuario"].map((String opcion) {
                    return DropdownMenuItem<String>(
                      value: opcion,
                      child: Text(opcion),
                    );
                  }).toList(),
                  onChanged: (value) {
                    debugPrint("Rol seleccionado: $value");
                  },
                ),
                SizedBox(height: 30), // Más espacio antes de los botones

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${user["name"]} aprobado")),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text("Aprobar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${user["name"]} rechazado")),
                        );
                        Navigator.pop(context);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Rechazar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para los títulos de los campos
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  // Widget para los valores de los campos
  Widget _buildValue(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 18),
    );
  }
}
