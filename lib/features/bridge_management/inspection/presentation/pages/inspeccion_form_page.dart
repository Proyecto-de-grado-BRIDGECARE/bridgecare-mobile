import 'dart:convert';
import 'package:bridgecare/features/bridge_management/inspection/models/componente.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/inspeccion.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/reparacion.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class InspectionFormScreen extends StatefulWidget {
  final int puenteId;

  const InspectionFormScreen({required this.puenteId, super.key});

  @override
  InspectionFormScreenState createState() => InspectionFormScreenState();
}

class InspectionFormScreenState extends State<InspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Map<String, dynamic>> _formData = {
    'puente': {},
    'inspeccion': {},
  };
  List<Map<String, String>> componentList = [];

  @override
  void initState() {
    super.initState();
    _loadComponents();
  }

  Future<void> _loadComponents() async {
    final String response =
        await rootBundle.loadString('assets/data/inspection_components.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      componentList =
          data.map((item) => Map<String, String>.from(item)).toList();
      // Initialize _formData with component keys after loading
      for (var component in componentList) {
        _formData[component['key']!] = {};
        _formData['reparaciones_${component['key']}'] = {};
      }
    });
  }

  int? _parseDropdownValue(String? value) {
    if (value == null) return null;
    final match = RegExp(r'^(\d+)\s*-').firstMatch(value);
    return match != null ? int.parse(match.group(1)!) : null;
  }

  Future<Map<String, dynamic>> _fetchPuenteData(int puenteId) async {
    // final response =
    //     await http.get(Uri.parse('https://your-api.com/puentes/$puenteId'));
    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body);
    // }
    // throw Exception('Failed to fetch Puente data');
    return Future.value({
      'nombre': 'Puente Ejemplo',
      'identificador': 'P001',
      'carretera': 'Carretera 123',
      'pr': 'PR 45',
    });
  }

  // ignore: unused_element
  Future<String> _fetchInspectorName(int usuarioId) async {
    // final response =
    //     await http.get(Uri.parse('https://your-api.com/usuarios/$usuarioId'));
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   return data['nombre'] ?? 'Desconocido';
    // }
    // return 'Desconocido';
    return Future.value('Inspector Prueba');
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Post Inspeccion
        _formData['inspeccion']!['puenteId'] = widget.puenteId;
        // _formData['inspeccion']!['usuarioId'] = widget.usuarioId;
        if (_formData['inspeccion']!['fecha'] != null) {
          _formData['inspeccion']!['fecha'] =
              (_formData['inspeccion']!['fecha'] as DateTime)
                  .toIso8601String()
                  .split('T')[0];
        }
        final inspeccionResponse = await http.post(
          Uri.parse('https://your-api.com/inspecciones'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(_formData['inspeccion']),
        );
        if (inspeccionResponse.statusCode != 201) {
          throw Exception(
              'Failed to create Inspeccion: ${inspeccionResponse.body}');
        }
        final inspeccionData = jsonDecode(inspeccionResponse.body);
        final inspeccionId = inspeccionData['id'] as int;

        // Post Componentes and Reparaciones
        for (var component in componentList) {
          final componentKey = component['key']!;
          final componenteData =
              Map<String, dynamic>.from(_formData[componentKey]!);
          componenteData['nombre'] =
              component['title']!.replaceAll('/', ' ').toUpperCase();
          componenteData['calificacion'] =
              _parseDropdownValue(componenteData['calificacion']?.toString());
          componenteData['tipoDanio'] =
              _parseDropdownValue(componenteData['tipoDanio']?.toString());
          componenteData['inspeccionId'] = inspeccionId;

          if (componenteData['imagenUrls'] != null &&
              (componenteData['imagenUrls'] as List).isNotEmpty) {
            final List<XFile> images =
                componenteData['imagenUrls'] as List<XFile>;
            final List<String> uploadedUrls = [];
            for (var image in images) {
              var request = http.MultipartRequest(
                'POST',
                Uri.parse(
                    'https://your-api.com/upload-image'), // Backend endpoint
              );
              request.files
                  .add(await http.MultipartFile.fromPath('image', image.path));
              final response = await request.send();
              if (response.statusCode == 200) {
                final responseData = await response.stream.bytesToString();
                final url = jsonDecode(responseData)['url'] as String;
                uploadedUrls.add(url);
              } else {
                throw Exception(
                    'Failed to upload image: ${response.reasonPhrase}');
              }
            }
            componenteData['imagenUrls'] =
                uploadedUrls; // Replace XFiles with URLs
          } else {
            componenteData['imagenUrls'] = null;
          }

          final componenteResponse = await http.post(
            Uri.parse('https://your-api.com/componentes'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(componenteData),
          );
          if (componenteResponse.statusCode != 201) {
            throw Exception(
                'Failed to create Componente $componentKey: ${componenteResponse.body}');
          }
          final componenteDataResponse = jsonDecode(componenteResponse.body);
          final componenteId = componenteDataResponse['id'] as int;

          final reparacionData = Map<String, dynamic>.from(
              _formData['reparaciones_$componentKey']!);
          if (reparacionData.isNotEmpty) {
            reparacionData['componenteId'] = componenteId;
            final reparacionResponse = await http.post(
              Uri.parse('https://your-api.com/reparaciones'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(reparacionData),
            );
            if (reparacionResponse.statusCode != 201) {
              throw Exception(
                  'Failed to create Reparacion for $componentKey: ${reparacionResponse.body}');
            }
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inspección enviada con éxito')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        _fetchPuenteData(widget.puenteId),
        // _fetchInspectorName(widget.usuarioId),
      ]).then((results) => {'puente': results[0], 'inspector': results[1]}),
      builder: (context, snapshot) {
        if (!snapshot.hasData || componentList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final puenteData = snapshot.data!['puente'] as Map<String, dynamic>;
        final inspectorName = snapshot.data!['inspector'] as String;

        // Populate initial Puente data
        _formData['puente'] = {
          'nombre': puenteData['nombre'],
          'identificador': puenteData['identificador'],
          'carretera': puenteData['carretera'],
          'pr': puenteData['pr'],
        };

        return FormTemplate(
          title: 'Formulario de Inspección',
          formKey: _formKey,
          onSave: _saveForm,
          sections: [
            FormSection(
              title: 'Información Básica',
              isCollapsible: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DynamicForm(
                    fields: Puente.formFields,
                    initialData: _formData['puente'],
                    onSave: (data) =>
                        setState(() => _formData['puente']!.addAll(data)),
                  ),
                  DynamicForm(
                    fields: Inspeccion.formFields,
                    initialData: _formData['inspeccion'],
                    onSave: (data) =>
                        setState(() => _formData['inspeccion']!.addAll(data)),
                  ),
                  TextFormField(
                    initialValue: inspectorName,
                    decoration: const InputDecoration(labelText: 'Inspector'),
                    readOnly: true,
                  ),
                ],
              ),
            ),
            ...componentList.map((component) {
              final componentKey = component['key']!;
              return FormSection(
                title: component['title']!,
                isCollapsible: true,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DynamicForm(
                      fields: Componente.formFields,
                      initialData: _formData[componentKey],
                      onSave: (data) =>
                          setState(() => _formData[componentKey]!.addAll(data)),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Reparaciones',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    DynamicForm(
                      fields: Reparacion.formFields,
                      initialData: _formData['reparaciones_$componentKey'],
                      onSave: (data) => setState(() =>
                          _formData['reparaciones_$componentKey']!
                              .addAll(data)),
                    ),
                  ],
                ),
              );
            }),
            FormSection(
              title: 'Observaciones Generales',
              isCollapsible: false,
              content: DynamicForm(
                fields: const {
                  'observacionesGenerales': {
                    'type': 'text',
                    'label': 'Observaciones Generales'
                  },
                },
                initialData: _formData['inspeccion'],
                onSave: (data) =>
                    setState(() => _formData['inspeccion']!.addAll(data)),
              ),
            ),
            FormSection(
              title: '',
              isCollapsible: false,
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'GUARDAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
