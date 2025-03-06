import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class buildForm extends StatefulWidget {
  final String tituloSeccion;
  final List<SectionData> secciones;

  buildForm({required this.tituloSeccion, required this.secciones, super.key});

  @override
  _buildFormState createState() => _buildFormState();
}

class _buildFormState extends State<buildForm> {
  Map<String, File?> _imagenesSecciones = {};

  Future<void> _pickImage(String sectionKey) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenesSecciones[sectionKey] = File(pickedFile.path);
      });
    }
  }

  // Convertir String a int
  int? toInt(String value) {
    return int.tryParse(value); // Retorna null si no es un número válido
  }

// Convertir String a double
  double? toDouble(String value) {
    return double.tryParse(value); // Retorna null si no es un número válido
  }

// Convertir String a booleano (S/N, 1/0, true/false)
  bool toBool(String value) {
    return value.trim().toLowerCase() == "s" ||
        value.trim() == "1" ||
        value.trim().toLowerCase() == "true";
  }

// Convertir String a DateTime (para fechas)
  DateTime? toDate(String value) {
    try {
      return DateTime.parse(
          value); // Intenta convertir el texto en formato yyyy-MM-dd
    } catch (e) {
      return null; // Retorna null si la fecha es inválida
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
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tituloSeccion,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    ...widget.secciones
                        .map((section) => _buildSection(section)),
                    SizedBox(height: 10),
                    Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xFF0097B2),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        child: Center(
                          child: ElevatedButton(
                              onPressed: _saveForm,
                              child: Text(
                                "Guardar formulario",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFFFFF)),
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Color(0xFFF29E23))),
                        ))
                  ],
                ))));
  }

  Widget _buildSection(SectionData section) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImagePicker(String sectionKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('subir imagen: ', style: GoogleFonts.poppins()),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(sectionKey),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: _imagenesSecciones[sectionKey] == null
                  ? Center(child: Text('toca para seleccionar una imagen'))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _imagenesSecciones[sectionKey]!,
                        fit: BoxFit.cover,
                      ))),
        )
      ],
    );
  }

  Widget _buildTextField(FieldData field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextField(
          controller: field.controller,
          decoration: InputDecoration(
              hintText: field.labelCampo, border: OutlineInputBorder())),
    );
  }

  void _saveForm() {
    bool allImagesSelected = widget.secciones.every((section) {
      return _imagenesSecciones[section.tituloSeccion] != null;
    });

    if (!allImagesSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Por favor, selecciona una imagen para cada sección.")),
      );
      return;
    }

    for (var section in widget.secciones) {
      for (var campo in section.campos) {
        String value = campo.controller.text;

        // **NÚMEROS (int o double)**
        if ([
          "Numero de luces",
          "Longitud Luz menor (m)",
          "Longitud luz mayor (m)",
          "Longitud total (m)",
          "Ancho del tablero (m)",
          "Ancho del separador (m)",
          "Ancho del anden izquierdo (m)",
          "Ancho del anden derecho (m)",
          "Ancho de calzada (m)",
          "Ancho entre bordillos (m)",
          "Ancho del acceso (m)",
          "Altura de pilas (m)",
          "Altura de estribos (m)",
          "Longitud de apoyo en pilas (m)",
          "Longitud de apoyo en estribos (m)",
          "Long. Luz critica (m)",
          "Latitud (N)",
          "Longitud (O)",
          "Longitud variante"
        ].contains(campo.labelCampo)) {
          double? doubleValue = toDouble(value);
          print("${campo.labelCampo}: ${doubleValue ?? 'Valor inválido'}");
        }

        // **FECHAS**
        else if ([
          "Año de construcción",
          "Año de reconstrucción",
          "Fecha de recolección de datos"
        ].contains(campo.labelCampo)) {
          DateTime? dateValue = toDate(value);
          print("${campo.labelCampo}: ${dateValue ?? 'Fecha inválida'}");
        }

        // **BOOLEANOS (BIT)**
        else if ([
          "Puente en terraplén (S/N)",
          "Puente en curva / Tangente (C/T)",
          "Primero (S/N)",
          "Diseño tipo (S/N)",
          "Diseño tipo 2 (S/N)",
          "Paso por el cause (S/N)",
          "Existe variante (S/N)"
        ].contains(campo.labelCampo)) {
          bool boolValue = toBool(value);
          print("${campo.labelCampo}: ${boolValue ? 'Sí' : 'No'}");
        }

        // **OTROS VALORES (SIN CONVERSIÓN)**
        else {
          print("${campo.labelCampo}: $value");
        }
      }

      final selectedImage = _imagenesSecciones[section.tituloSeccion];
      if (selectedImage != null) {
        print("Imagen para ${section.tituloSeccion}: ${selectedImage.path}");
      }
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Formulario guardado con éxito")));
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
