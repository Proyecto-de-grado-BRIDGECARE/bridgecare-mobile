import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class BuildForm extends StatefulWidget {
  final String tituloSeccion;
  final List<SectionData> secciones;

  const BuildForm({
    required this.tituloSeccion,
    required this.secciones,
    super.key,
  });

  @override
  BuildFormState createState() => BuildFormState();
}

class BuildFormState extends State<BuildForm> {
  final Map<String, File?> _imagenesSecciones = {};

  Future<void> _pickImage(String sectionKey) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
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
        value,
      ); // Intenta convertir el texto en formato yyyy-MM-dd
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
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFFF29E23),
                    ),
                    child: Text(
                      "Guardar formulario",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(SectionData section) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      child: ExpansionTile(
        title: Text(
          section.tituloSeccion,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...section.campos.map((campo) => _buildField(campo)),
                _buildImagePicker(section.tituloSeccion),
              ],
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: _imagenesSecciones[sectionKey] == null
                ? Center(child: Text('toca para seleccionar una imagen'))
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

  Widget _buildField(FieldData field) {
    // Si el campo tiene opciones, usa _buildOpciones()
    if (field.opciones != null && field.opciones!.isNotEmpty) {
      if (field.labelCampo == "Diseño tipo (S/N)") {
        // Manejo especial para "Diseño tipo (S/N)"
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DropdownButtonFormField<String>(
            value: field.controller.text.isNotEmpty
                ? (field.controller.text == "1"
                    ? "S"
                    : "N") // Convierte 1 -> "S" y 0 -> "N"
                : null,
            decoration: InputDecoration(
              labelText: field.labelCampo,
              border: OutlineInputBorder(),
            ),
            items: ["S", "N"].map((String opcion) {
              return DropdownMenuItem<String>(
                value: opcion,
                child: Text(opcion),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                field.controller.text = newValue == "S"
                    ? "1"
                    : "0"; // Guarda "S" como 1 y "N" como 0
              }
            },
            validator: (value) {
              if (value == null) {
                return "Seleccione una opción";
              }
              return null;
            },
          ),
        );
      }
      return _buildOpciones(field);
    }
    // Manejo especial para los campos de año
    else if ([
      "Año de construcción",
      "Año de reconstrucción",
      "Fecha de recolección de datos",
    ].contains(field.labelCampo)) {
      return GestureDetector(
        onTap: () => _seleccionarAno(context, field),
        child: AbsorbPointer(
          child: TextFormField(
            controller: field.controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: field.labelCampo,
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today), // Ícono de calendario
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Seleccione el año";
              }
              int? year = int.tryParse(value);
              if (year == null || year < 1900 || year > DateTime.now().year) {
                return "Ingrese un año válido";
              }
              return null;
            },
          ),
        ),
      );
    }

    // Para todos los demás campos
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        controller: field.controller,
        keyboardType:
            field.numerico ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: field.labelCampo,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor ingrese ${field.labelCampo}";
          }
          return null;
        },
      ),
    );
  }

  Future<void> _seleccionarAno(BuildContext context, FieldData campo) async {
    DateTime fechaActual = DateTime.now();
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: DateTime(1900),
      lastDate: fechaActual,
      fieldHintText: "Seleccione el año",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF003366), // Color del DatePicker
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fechaSeleccionada != null) {
      setState(() {
        campo.controller.text =
            fechaSeleccionada.year.toString(); // Solo el año
      });
    }
  }

  Widget _buildOpciones(FieldData field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: field.labelCampo,
          border: OutlineInputBorder(),
        ),
        value: field.valorSeleccionado,
        items: field.opciones?.map((opcion) {
          return DropdownMenuItem(value: opcion, child: Text(opcion));
        }).toList(),
        onChanged: (value) {
          setState(() {
            field.valorSeleccionado = value;
          });
        },
      ),
    );
  }

  void _saveForm() {
    for (var section in widget.secciones) {
      for (var campo in section.campos) {
        String value = campo.controller.text;

        // *NÚMEROS (int o double)*
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
          "Longitud variante",
        ].contains(campo.labelCampo)) {
          double? doubleValue = toDouble(value);
          debugPrint("${campo.labelCampo}: ${doubleValue ?? 'Valor inválido'}");
        }
        // *FECHAS*
        else if ([
          "Año de construcción",
          "Año de reconstrucción",
          "Fecha de recolección de datos",
        ].contains(campo.labelCampo)) {
          DateTime? dateValue = toDate(value);
          debugPrint("${campo.labelCampo}: ${dateValue ?? 'Fecha inválida'}");
        }
        // *BOOLEANOS (BIT)*
        else if ([
          "Puente en terraplén (S/N)",
          "Puente en curva / Tangente (C/T)",
          "Primero (S/N)",
          "Diseño tipo (S/N)",
          "Diseño tipo 2 (S/N)",
          "Paso por el cause (S/N)",
          "Existe variante (S/N)",
        ].contains(campo.labelCampo)) {
          bool boolValue = toBool(value);
          debugPrint("${campo.labelCampo}: ${boolValue ? 'Sí' : 'No'}");
        }
        // *SELECCIÓN ÚNICA (Dropdown o RadioListTile)*
        else if (campo.opciones != null) {
          debugPrint(
            "${campo.labelCampo}: ${campo.valorSeleccionado ?? 'No seleccionado'}",
          );
        }
        // *OTROS VALORES (TEXTOS)*
        else {
          debugPrint("${campo.labelCampo}: $value");
        }
      }

      // Si el usuario subió una imagen, se guarda; si no, se ignora
      final selectedImage = _imagenesSecciones[section.tituloSeccion];
      if (selectedImage != null) {
        debugPrint(
          "Imagen para ${section.tituloSeccion}: ${selectedImage.path}",
        );
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Formulario guardado con éxito")));
    Navigator.pushReplacementNamed(context, '/inspeccionForm');
  }

}

class SectionData {
  final String tituloSeccion;
  final List<FieldData> campos;

  SectionData({required this.tituloSeccion, required this.campos});
}

class FieldData {
  final String labelCampo;
  final TextEditingController controller;
  final List<String>? opciones;
  String? valorSeleccionado;
  final bool numerico;

  FieldData({
    required this.labelCampo,
    required this.controller,
    this.opciones,
    this.numerico = false,
    this.valorSeleccionado,
  });
}
