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
import 'package:shared_preferences/shared_preferences.dart';
import '../../../alert/presentation/pages/alert_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class InspectionFormScreen extends StatefulWidget {
  final int puenteId;

  const InspectionFormScreen(
      { required this.puenteId, super.key, required int usuarioId});

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
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _loadComponents();
    _loadUserIdFromToken();
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
  Future<void> _loadUserIdFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('usuario_id');
    if (userId != null) {
      setState(() {
        usuarioId = userId;
      });
    } else {
      debugPrint("❌ No se encontró usuario_id en SharedPreferences");
    }
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
        if (_formData['inspeccion']!['fecha'] != null) {
          _formData['inspeccion']!['fecha'] =
          (_formData['inspeccion']!['fecha'] as DateTime)
              .toIso8601String()
              .split('T')[0];
        }

        // Construir componentes con imágenes subidas
        final componentes = await Future.wait(componentList.map((component) async {
          final componentKey = component['key']!;
          final comp = Map<String, dynamic>.from(_formData[componentKey] ?? {});
          final reparacion = _formData['reparaciones_$componentKey'] ?? {};

          // Subida de imágenes
          List<String> uploadedUrls = [];
          if (comp['imagenUrls'] != null && (comp['imagenUrls'] as List).isNotEmpty) {
            final List<XFile> images = comp['imagenUrls'] as List<XFile>;
            for (var image in images) {
              var request = http.MultipartRequest(
                'POST',
                Uri.parse('http://192.168.20.24:8083/api/imagenes/upload'), // Actualiza si tu endpoint es otro
              );
              request.files.add(await http.MultipartFile.fromPath('image', image.path));

              final response = await request.send();
              if (response.statusCode == 200) {
                final responseData = await response.stream.bytesToString();
                final url = jsonDecode(responseData)['url'] as String;
                uploadedUrls.add(url);
              } else {
                throw Exception('Fallo al subir imagen: ${response.reasonPhrase}');
              }
            }
          }

          return {
            'nomb': component['title']!.replaceAll('/', ' ').toUpperCase(),
            'calificacion': _parseDropdownValue(comp['calificacion']?.toString()),
            'mantenimiento': comp['mantenimiento'] ?? '',
            'inspEesp': comp['inspEesp'] ?? '',
            'numeroFfotos': int.tryParse(comp['numeroFfotos']?.toString() ?? '0'),
            'tipoDanio': _parseDropdownValue(comp['tipoDanio']?.toString()),
            'danio': comp['danio'] ?? '',
            'imagenUrls': uploadedUrls.isNotEmpty ? uploadedUrls : null,
            'reparacion': reparacion.isNotEmpty ? [reparacion] : []
          };
        }).toList());

        if (usuarioId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo obtener el usuario autenticado')),
          );
          return;
        }


        // Armar objeto inspección
        final inspeccion = {
          ..._formData['inspeccion']!,
          'usuario': {'id': usuarioId},
          'puente': {'id': widget.puenteId},
          'componentes': componentes,
        };

        final prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        if (token == null || token.isEmpty) {
          debugPrint('❌ Error: No token found in SharedPreferences');
          return;
        }
        final decoded = JwtDecoder.decode(token);
        debugPrint('🔍 Token decodificado: $decoded');
        //if (token == null) {
        //   debugPrint('Error: No token found in SharedPreferences');
        // return;
        // }
        final userId = prefs.getInt('usuario_id');
        if (userId != null) {
          _formData['usuario']?['id'] = userId;
        } else {
          debugPrint("No se encontró usuario_id en SharedPreferences");
          return;
        }

        print('Token: $token');
        print('Request Body: ${jsonEncode(inspeccion)}');

        // Enviar inspección
        final response = await http.post(
          Uri.parse('http://192.168.20.24:8083/api/inspeccion/add'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(inspeccion),
        );

        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inspección enviada con éxito')),
          );

          final hayAlertas = await _tieneAlertas(widget.puenteId);
          if (hayAlertas && mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¡Atención!'),
                content: const Text(
                    'Se han generado alertas para esta inspección. ¿Deseas revisarlas?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AlertScreen(puenteId: widget.puenteId),
                        ),
                      );
                    },
                    child: const Text('Ver alertas'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          }
        } else {
          throw Exception('Error al enviar inspección: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        _fetchPuenteData(widget.puenteId),
        _fetchInspectorName(usuarioId ?? 0),
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
  Future<bool> _tieneAlertas(int puenteId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.20.24:8086/api/alertas/puente/$puenteId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      print('Error al verificar alertas: $e');
      return false;
    }
  }
  Future<String> _getToken() async {
    // Usa SharedPreferences u otro método según tu app
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }


}