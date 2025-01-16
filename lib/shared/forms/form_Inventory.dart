import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bridgecare/features/assets/presentation/pages/buildForm.dart';
// import 'package:image_picker/image_picker.dart';

class FormInventory extends StatefulWidget {
  const FormInventory({super.key});

  @override
  State<FormInventory> createState() => _FormInventoryState();
}

class _FormInventoryState extends State<FormInventory> {
  TextEditingController bridgeName = TextEditingController();
  TextEditingController regionalId = TextEditingController();
  TextEditingController roadId = TextEditingController();
  TextEditingController bridgeId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Formulario de Inventario",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFEBEBEB),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _buildForm(),
      ),
    );
  }
}
