import 'package:bridgecare/features/administrador/user_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutorizacionUsuario extends StatefulWidget {
  const AutorizacionUsuario({super.key});

  @override
  State<AutorizacionUsuario> createState() => _AutorizacionPage();
}

class _AutorizacionPage extends State<AutorizacionUsuario> {
  List<Map<String, String>> usuariosPendientes = [
    {
      "name": "Carlos Mendoza",
      "email": "carlos@example.com",
      "date": "12/03/2025",
    },
    {
      "name": "Ana López",
      "email": "ana@example.com",
      "date": "10/03/2025",
    },
    {
      "name": "Luis Torres",
      "email": "luis@example.com",
      "date": "08/03/2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Color(0xFFEBEBEB), // Mismo color de fondo
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("notificaciones")));
                    },
                    icon: Icon(Icons.notifications, color: Colors.black),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  "Usuarios pendientes por actualizar",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: usuariosPendientes.length,
          itemBuilder: (context, index) {
            final user = usuariosPendientes[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(Icons.person, size: 40),
                title: Text(user["name"]!),
                subtitle: Text(user["email"]!),
                trailing: Text(user["date"]!),
                onTap: () {
                  // Navegar a pantalla de detalles
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesUsuario(user: user),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
