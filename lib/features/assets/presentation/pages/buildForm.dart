import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class buildForm extends StatelessWidget {
  final String tituloSeccion;
  final List<SectionData> secciones;

  const buildForm(
      {required this.tituloSeccion, required this.secciones, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tituloSeccion,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    ...secciones
                        .map((section) => _buildSection(section))
                        .toList(),
                  ],
                ))));
  }

  Widget _buildSection(SectionData section) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.tituloSeccion,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          ...section.campos.map((campos) => _buildTextField(campos)).toList()
        ],
      ),
    );
  }

  Widget _buildTextField(FieldData field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        controller: field.controller,
        decoration: InputDecoration(
            hintText: field.labelCampo, border: OutlineInputBorder()),
      ),
    );
  }
}

class SectionData {
  final String tituloSeccion;
  final List<FieldData> campos;

  SectionData({
    required this.tituloSeccion,
    required this.campos,
  });
}

class FieldData {
  final String labelCampo;
  final TextEditingController controller;

  FieldData({required this.labelCampo, required this.controller});
}
