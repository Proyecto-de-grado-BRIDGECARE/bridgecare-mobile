import 'dart:convert';
import 'package:bridgecare/features/bridge_management/alert/presentation/pages/alert_page.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/componente.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/inspeccion.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/reparacion.dart';
import 'package:bridgecare/shared/help_loader.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'package:bridgecare/shared/widgets/help_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http_parser/http_parser.dart' as parser;

class InspectionFormScreen extends StatefulWidget {
  final int puenteId;

  const InspectionFormScreen({required this.puenteId, super.key});

  @override
  InspectionFormScreenState createState() => InspectionFormScreenState();
}

class InspectionFormScreenState extends State<InspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<Map<String, HelpInfo>> helpSectionsFuture;
  Map<String, HelpInfo> helpSections = {};
  final Map<String, Map<String, dynamic>> _formData = {
    'puente': {},
    'inspeccion': {},
  };
  List<Map<String, String>> componentList = [];
  int? usuarioId;
  late Future<void> initFuture;

  @override
  void initState() {
    super.initState();
    helpSectionsFuture = loadHelpSections();
    initFuture = _initialize();
  }

  Future<void> _initialize() async {
    await _loadComponents();
    await _loadUserIdFromToken();
  }

  Future<void> _loadComponents() async {
    final String response =
        await rootBundle.loadString('assets/data/inspection_components.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      componentList =
          data.map((item) => Map<String, String>.from(item)).toList();
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
      debugPrint("No se encontró usuario_id en SharedPreferences");
    }
  }

  int? _parseDropdownValue(String? value) {
    if (value == null) return null;
    final match = RegExp(r'^(\d+)\s*-').firstMatch(value);
    return match != null ? int.parse(match.group(1)!) : null;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_formData['inspeccion']!['fecha'] != null) {
          DateTime fecha;
          if (_formData['inspeccion']!['fecha'] is String) {
            fecha = DateTime.parse(_formData['inspeccion']!['fecha'] as String);
          } else if (_formData['inspeccion']!['fecha'] is DateTime) {
            fecha = _formData['inspeccion']!['fecha'] as DateTime;
          } else {
            throw Exception('Invalid fecha format');
          }
          _formData['inspeccion']!['fecha'] =
              fecha.toIso8601String().split('T')[0];
        }

        // Construir componentes con imágenes
        final componentes =
            await Future.wait(componentList.map((component) async {
          final componentKey = component['key']!;
          final comp = Map<String, dynamic>.from(_formData[componentKey] ?? {});
          final reparacion = _formData['reparaciones_$componentKey'] ?? {};
          List<String> imagePaths = [];
          if (comp['imagenUrls'] != null &&
              (comp['imagenUrls'] as List).isNotEmpty) {
            imagePaths =
                (comp['imagenUrls'] as List<XFile>).map((x) => x.path).toList();
          }

          return {
            'nomb': component['title']!.replaceAll('/', ' ').toUpperCase(),
            'calificacion':
                _parseDropdownValue(comp['calificacion']?.toString()),
            'mantenimiento': comp['mantenimiento'] ?? '',
            'inspEesp': comp['inspEesp'] ?? '',
            'numeroFfotos':
                int.tryParse(comp['numeroFfotos']?.toString() ?? '0'),
            'tipoDanio': _parseDropdownValue(comp['tipoDanio']?.toString()),
            'danio': comp['danio'] ?? '',
            'imagenUrls': imagePaths.isNotEmpty ? imagePaths : null,
            'reparacion': reparacion.isNotEmpty ? [reparacion] : []
          };
        }).toList());

        if (usuarioId == null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo obtener el usuario autenticado')),
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
          debugPrint('Error: No token found in SharedPreferences');
          return;
        }

        // Check connectivity
        List<ConnectivityResult> connectivityResults =
            await Connectivity().checkConnectivity();
        bool isConnected =
            !connectivityResults.contains(ConnectivityResult.none);

        List<String> allImagePaths = componentes
            .where((c) => c['imagenUrls'] != null)
            .expand((c) => c['imagenUrls'] as List<String>)
            .toList();

        if (isConnected) {
          final prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          if (token == null || token.isEmpty) {
            debugPrint('Error: No token found in SharedPreferences');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('No se encontró el token de autenticación')),
              );
            }
            return;
          }

          // Validate token
          try {
            bool isExpired = JwtDecoder.isExpired(token);
            if (isExpired) {
              debugPrint('Error: Token is expired');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Sesión expirada. Por favor, inicia sesión de nuevo')),
                );
              }
              // Optionally redirect to login screen
              return;
            }
          } catch (e) {
            debugPrint('Error decoding token: $e');
          }

          var request = http.MultipartRequest(
            'POST',
            Uri.parse('https://api.bridgecare.com.co/inspeccion/add'),
          );
          request.headers['Authorization'] = 'Bearer $token';
          // Let http package set multipart/form-data with boundary automatically
          // request.headers['Content-Type'] = 'multipart/form-data'; // Not needed
          request.fields['inspeccion'] = jsonEncode(inspeccion);
          // Set Content-Type for inspeccion part (optional, for clarity)
          request.files.add(http.MultipartFile.fromString(
            'inspeccion',
            jsonEncode(inspeccion),
            contentType: parser.MediaType('application', 'json'),
          ));
          for (var path in allImagePaths) {
            request.files
                .add(await http.MultipartFile.fromPath('images', path));
          }

          debugPrint('Request Headers: ${request.headers}');
          debugPrint('Request Fields: ${request.fields}');
          debugPrint(
              'Request Files: ${request.files.map((f) => f.filename).toList()}');

          try {
            final response = await request.send();
            final responseBody = await response.stream.bytesToString();
            debugPrint('Response Status: ${response.statusCode}');
            debugPrint('Response Body: $responseBody');

            if (response.statusCode == 200 || response.statusCode == 201) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inspección enviada con éxito')),
                );
              }
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
                        onPressed: () {
                          Navigator.pop(context);  // Cierra el diálogo
                          Navigator.pushNamed(context, '/home');  // Navega a home
                        },
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              }
            } else {
              throw Exception(
                  'Error al enviar inspección: ${response.statusCode} - $responseBody');
            }
          } catch (e) {
            debugPrint('Request failed: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al enviar inspección: $e')),
              );
            }
          }
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
    return FutureBuilder<Map<String, HelpInfo>>(
      future: helpSectionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error cargando ayuda contextual'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No hay datos de ayuda disponibles'));
        }
        helpSections = snapshot.data!;

        return FormTemplate(
          title: 'Formulario de Inspección',
          formKey: _formKey,
          onSave: _saveForm,
          sections: [
            FormSection(
              titleWidget: const Text('Información Básica',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              isCollapsible: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DynamicForm(
                    fields: Inspeccion.formFields,
                    initialData: _formData['inspeccion'],
                    onSave: (data) =>
                        setState(() => _formData['inspeccion']!.addAll(data)),
                  ),
                ],
              ),
            ),
            ...componentList.map((component) {
              final componentKey = component['key']!;
              return FormSection(
                titleWidget: DefaultSectionTitle(
                  text: component['title']!,
                  trailing: HelpIconButton(
                    helpKey: componentKey,
                    helpSections: helpSections,
                  ),
                ),
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
                        color: Colors.blueGrey,
                      ),
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
              titleWidget: const Text('Observaciones Generales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              titleWidget: const SizedBox.shrink(),
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
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        debugPrint('Error: No token found in SharedPreferences');
        return false;
      }

      final response = await http.get(
        Uri.parse('https://api.bridgecare.com.co/alerta/puente/$puenteId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Alerta response status: ${response.statusCode}');
      debugPrint('Alerta response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error al verificar alertas: $e');
      return false;
    }
  }
}
