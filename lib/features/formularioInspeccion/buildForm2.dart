import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class BuildForm extends StatefulWidget {
  final String tituloSeccion;
  final List<SectionData> secciones;

  BuildForm({required this.tituloSeccion, required this.secciones, super.key});

  @override
  _BuildFormState createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
  Map<String, File?> _imagenesSecciones = {};

  Future<void> _pickImage(String sectionKey) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenesSecciones[sectionKey] = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.tituloSeccion,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              ...widget.secciones.map((section) => _buildSection(section)),
              SizedBox(height: 10),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0097B2),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text(
                      "Guardar formulario",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFFF29E23),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(SectionData section) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(section.tituloSeccion,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...section.campos.map((campo) => _buildTextField(campo)),
                _buildImagePicker(section.tituloSeccion),

                // Renderizar subsecciones si existen
                if (section.subsecciones != null)
                  ...section.subsecciones!.map((subsection) => _buildSubsection(subsection)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubsection(SectionData subsection) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: ExpansionTile(
        title: Text(
          subsection.tituloSeccion,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: subsection.campos.map((campo) => _buildTextField(campo)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(String sectionKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subir imagen: ', style: GoogleFonts.poppins()),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(sectionKey),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _imagenesSecciones[sectionKey] == null
                ? Center(child: Text('Toca para seleccionar una imagen'))
                : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _imagenesSecciones[sectionKey]!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(FieldData field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: field.controller,
        decoration: InputDecoration(
          labelText: field.labelCampo,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _saveForm() {
    bool allImagesSelected = widget.secciones.every((section) {
      return _imagenesSecciones[section.tituloSeccion] != null;
    });

    if (!allImagesSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, selecciona una imagen para cada sección.")),
      );
      return;
    }

    for (var section in widget.secciones) {
      for (var campo in section.campos) {
        print("${campo.labelCampo}: ${campo.controller.text}");
      }
      print("Imagen para ${section.tituloSeccion}: ${_imagenesSecciones[section.tituloSeccion]?.path}");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Formulario guardado con éxito")),
    );
  }
}

class SectionData {
  final String tituloSeccion;
  final List<FieldData> campos;
  final List<SectionData>? subsecciones;

  SectionData({required this.tituloSeccion, required this.campos, this.subsecciones});
}

class FieldData {
  final String labelCampo;
  final TextEditingController controller;

  FieldData({required this.labelCampo, required this.controller});
}
