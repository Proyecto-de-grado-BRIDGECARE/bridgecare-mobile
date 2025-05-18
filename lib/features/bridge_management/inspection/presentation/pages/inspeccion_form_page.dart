import 'dart:convert';
import 'package:bridgecare/features/auth/services/auth_service.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/componente.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/inspeccion.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/reparacion.dart';
import 'package:bridgecare/shared/services/api_service.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_manager.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class InspectionFormScreen extends StatefulWidget {
  final int puenteId;

  const InspectionFormScreen({required this.puenteId, super.key});

  @override
  InspectionFormScreenState createState() => InspectionFormScreenState();
}

class InspectionFormScreenState extends State<InspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _inspectionFormData = {
    'inspeccionData': <String, dynamic>{},
  };

  final Map<String, dynamic> _formData = {
    'puente': <String, dynamic>{},
    'usuario': <String, dynamic>{},
    'componentes': <Map<String, dynamic>>[],
  };
  List<Map<String, String>> componentList = [];
  final String tempInspectionId = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    _loadComponents();
    _loadUserIntoFormData();
  }

  Future<void> _loadComponents() async {
    final String response =
        await rootBundle.loadString('assets/data/inspection_components.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      componentList =
          data.map((item) => Map<String, String>.from(item)).toList();
      _formData['componentes'] = componentList.map((component) {
        return {
          'nombre': component['title']!,
          'calificacion': '',
          'tipoDanio': '',
          'reparaciones': <Map<String, String>>[
            {'tipo': '', 'cantidad': '', 'anio': '', 'costo': ''},
            {'tipo': '', 'cantidad': '', 'anio': '', 'costo': ''},
          ],
        };
      }).toList();
    });
  }

  Future<void> _loadUserIntoFormData() async {
    final user = await AuthService().getUser();
    if (user != null) {
      setState(() {
        _formData['usuario'] = {
          'id': user.id,
          'nombres': user.nombres,
          'apellidos': user.apellidos,
          'identificacion': user.identificacion,
          'tipo_usuario': user.tipoUsuario,
          'correo': user.correo,
          if (user.municipio != null) 'municipio': user.municipio,
        };
      });
    } else {
      debugPrint("Failed to load user data");
    }
  }

  int? _parseDropdownValue(String? value) {
    if (value == null) return null;
    final match = RegExp(r'^(\d+)\s*-').firstMatch(value);
    return match != null ? int.parse(match.group(1)!) : null;
  }

  Future<Map<String, dynamic>> _fetchPuenteData(int puenteId) async {
    return Future.value({
      'nombre': 'Puente Ejemplo',
      'identificador': 'P001',
      'carretera': 'Carretera 123',
      'pr': 'PR 45',
    });
  }

  Future<String> _fetchInspectorName() async {
    return Future.value('Inspector Prueba');
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final queueManager = context.read<QueueManager>();
        final dbService = context.read<DatabaseService>();
        final apiService = context.read<ApiService>();

        // Prepare inspeccion data
        _formData['inspeccion']!['puenteId'] = widget.puenteId;
        if (_formData['inspeccion']!['fecha'] != null) {
          _formData['inspeccion']!['fecha'] =
              (_formData['inspeccion']!['fecha'] as DateTime)
                  .toIso8601String()
                  .split('T')[0];
        }

        // Prepare inspection JSON
        final inspectionData = {
          'puente': {'id': widget.puenteId},
          'usuario': _formData['usuario'],
          'inspeccion': _formData['inspeccion'],
          'componentes': <Map<String, dynamic>>[],
          'reparaciones': <Map<String, dynamic>>[],
        };

        debugPrint('Sending inspectionData: ${jsonEncode(inspectionData)}');

        String? inspeccionId;
        try {
          final inspeccionResponse = await apiService.uploadInspectionJson(
            inspectionData,
            widget.puenteId,
            tempInspectionId,
          );
          if (inspeccionResponse.statusCode == 200) {
            final responseBody = jsonDecode(inspeccionResponse.body);
            final message = responseBody['message'] as String;
            final idMatch = RegExp(r'ID: (\d+)').firstMatch(message);
            inspeccionId = idMatch?.group(1);
            if (inspeccionId == null) {
              throw Exception('Failed to parse inspeccionId');
            }
            // Update image_chunks and image_urls with real inspeccionId
            await dbService.updateInspectionId(tempInspectionId, inspeccionId);
          } else {
            throw Exception(
                'Failed to create Inspeccion: ${inspeccionResponse.body}');
          }
        } catch (e) {
          debugPrint('Inspeccion post failed, queuing: $e');
        }

        // Process components and include image URLs
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
          componenteData['componenteKey'] = componentKey;
          // Fetch image URLs for this component
          final imageUrls = await dbService.getImageUrls(
              inspeccionId?.toString() ?? tempInspectionId, componentKey);
          componenteData['imagenUrls'] = imageUrls;

          (inspectionData['componentes'] as List<Map<String, dynamic>>)
              .add(componenteData);

          final reparacionData = Map<String, dynamic>.from(
              _formData['reparaciones_$componentKey']!);
          if (reparacionData.isNotEmpty) {
            reparacionData['componenteKey'] = componentKey;
            (inspectionData['reparaciones'] as List<Map<String, dynamic>>)
                .add(reparacionData);
          }
        }

        // Queue inspection JSON
        await queueManager.queueInspectionJson(
          inspectionData,
          widget.puenteId,
          inspeccionId,
        );
        // Trigger queue processing
        await queueManager.processQueue();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Inspección en cola para sincronización')),
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
        _fetchInspectorName(),
      ]).then((results) => {'puente': results[0], 'inspector': results[1]}),
      builder: (context, snapshot) {
        if (!snapshot.hasData || componentList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final inspectorName = snapshot.data!['inspector'] as String;

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
                  DynamicForm(
                    fields: {
                      'inspector': {
                        'type': 'text',
                        'label': 'Inspector',
                        'readOnly': true,
                      },
                    },
                    initialData: {'inspector': inspectorName},
                    onSave: (_) {},
                  ),
                ],
              ),
            ),
            ...componentList.asMap().entries.map((entry) {
              final index = entry.key;
              final component = entry.value;
              return FormSection(
                title: component['title']!,
                isCollapsible: true,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DynamicForm(
                      fields: Componente.formFields,
                      initialData: _formData['componentes'][index],
                      onSave: (data) {
                        setState(() {
                          _formData['componentes'][index]
                              .addAll(Map<String, String>.from(data));
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Reparación 1',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    DynamicForm(
                      fields: Reparacion.formFields,
                      initialData: _formData['componentes'][index]
                          ['reparaciones'][0],
                      onSave: (data) {
                        setState(() {
                          _formData['componentes'][index]['reparaciones'][0]
                              .addAll(Map<String, String>.from(data));
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Reparación 2',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    DynamicForm(
                      fields: Reparacion.formFields,
                      initialData: _formData['componentes'][index]
                          ['reparaciones'][1],
                      onSave: (data) {
                        setState(() {
                          _formData['componentes'][index]['reparaciones'][1]
                              .addAll(Map<String, String>.from(data));
                        });
                      },
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
