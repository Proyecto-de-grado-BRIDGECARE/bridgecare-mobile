import 'dart:convert';
import 'package:bridgecare/features/bridge_management/alert/presentation/pages/alert_page.dart';
import 'package:bridgecare/features/bridge_management/inspection/controllers/inspection_controller.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/componente.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/inspeccion.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/reparacion.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/shared/widgets/queue_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionFormScreen extends StatefulWidget {
  final int puenteId;

  const InspectionFormScreen({required this.puenteId, super.key});

  @override
  InspectionFormScreenState createState() => InspectionFormScreenState();
}

class InspectionFormScreenState extends State<InspectionFormScreen> {
  List<Map<String, String>> componentList = [];
  String? inspectorName;

  @override
  void initState() {
    super.initState();
    _loadComponents();
    _loadInspectorName();
  }

  Future<void> _loadComponents() async {
    final String response =
        await rootBundle.loadString('assets/data/inspection_components.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      componentList =
          data.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  Future<void> _loadInspectorName() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('usuario_id');
    if (userId != null) {
      // Mocked for now; replace with API call if needed
      setState(() {
        inspectorName = 'Inspector Prueba';
      });
    } else {
      debugPrint("No se encontró usuario_id en SharedPreferences");
    }
  }

  Future<Map<String, dynamic>> _fetchPuenteData(int puenteId) async {
    return Future.value({
      'nombre': 'Puente Ejemplo',
      'identificador': 'P001',
      'carretera': 'Carretera 123',
      'pr': 'PR 45',
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InspectionController(
        puenteId: widget.puenteId,
        componentList: componentList,
        databaseService: DatabaseService(),
        queueService: QueueService(),
      ),
      child: Consumer<InspectionController>(
        builder: (context, controller, _) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(title: const Text('Formulario de Inspección')),
                body: FutureBuilder<Map<String, dynamic>>(
                  future: _fetchPuenteData(widget.puenteId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        componentList.isEmpty ||
                        inspectorName == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final puenteData = snapshot.data!;
                    controller.setPuenteData(puenteData);
                    return FormTemplate(
                      title: 'Formulario de Inspección',
                      formKey: controller.formKey,
                      onSave: () async {
                        try {
                          await controller.submitForm();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Inspección guardada y en cola')),
                            );
                          }
                          final hayAlertas =
                              await _tieneAlertas(widget.puenteId);
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
                                          builder: (context) => AlertScreen(
                                              puenteId: widget.puenteId),
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
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      sections: [
                        FormSection(
                          title: 'Información Básica',
                          isCollapsible: true,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DynamicForm(
                                fields: Puente.formFields,
                                initialData: puenteData,
                                onSave: (data) =>
                                    controller.updatePuenteData(data),
                              ),
                              DynamicForm(
                                fields: Inspeccion.formFields,
                                initialData: controller.inspeccion.toJson(),
                                onSave: (data) =>
                                    controller.updateInspeccionData(data),
                              ),
                              TextFormField(
                                initialValue: inspectorName,
                                decoration: const InputDecoration(
                                    labelText: 'Inspector'),
                                readOnly: true,
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
                                  fields: {
                                    ...Componente.formFields,
                                    'imagenUrls': {
                                      'type': 'image',
                                      'label': 'Fotos',
                                      'maxImages': 5,
                                    },
                                  },
                                  initialData: controller
                                      .inspeccion.componentes[index]
                                      .toJson(),
                                  onSave: (data) => controller
                                      .updateComponenteData(index, data),
                                  extraData: {
                                    'puenteId': widget.puenteId.toString(),
                                    'inspeccionUuid':
                                        controller.inspeccion.inspeccionUuid,
                                    'componenteUuid': controller.inspeccion
                                        .componentes[index].componenteUuid,
                                  },
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
                                  initialData: controller.inspeccion
                                          .componentes[index].reparacion
                                          ?.toJson() ??
                                      {},
                                  onSave: (data) => controller
                                      .updateReparacionData(index, data),
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
                                'label': 'Observaciones Generales',
                              },
                            },
                            initialData: controller.inspeccion.toJson(),
                            onSave: (data) =>
                                controller.updateInspeccionData(data),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: ElevatedButton(
                                    onPressed: controller.submitForm,
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
                ),
              ),
              if (controller.isWidgetVisible)
                QueueProgressWidget(
                  queueService: controller.queueService,
                  onHide: controller.hideWidget,
                  onTap: () async {
                    final failedTasks =
                        await controller.queueService.getFailedTasks();
                    if (failedTasks.isNotEmpty) {
                      await controller.queueService.retryFailedTasks();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Retrying failed tasks...')),
                        );
                      }
                    } else {
                      await controller.queueService.processQueue();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('No failed tasks, refreshing queue...')),
                        );
                      }
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _tieneAlertas(int puenteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        debugPrint('Error: No token found in SharedPreferences');
        return false;
      }

      final response = await http.get(
        Uri.parse('http://192.168.20.24:8086/api/alerta/puente/$puenteId'),
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
