import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class buildForm extends StatelessWidget {
  final String titulo;
  final List<SectionData> secciones;

  const buildForm({required this.titulo, required this.secciones, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          ...secciones.map((section) => _buildSection(section)).toList(),
        ],
      ),
    );
  }

  Widget _buildSection(SectionData section) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.tituloSeccion,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
          TextFormField(
            controller: section.controller,
            decoration: InputDecoration(
                hintText: section.labelCampo, border: OutlineInputBorder()),
          )
        ],
      ),
    );
  }
}

class SectionData {
  final String tituloSeccion;
  final String labelCampo;
  final TextEditingController controller;

  SectionData(
      {required this.tituloSeccion,
      required this.labelCampo,
      required this.controller});
}
