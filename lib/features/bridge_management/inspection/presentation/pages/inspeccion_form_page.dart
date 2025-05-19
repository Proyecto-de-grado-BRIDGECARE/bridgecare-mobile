import 'dart:convert';

import 'package:bridgecare/features/bridge_management/alert/presentation/pages/alert_page.dart';
import 'package:bridgecare/features/bridge_management/inspection/controllers/inspection_controller.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/componente.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/inspeccion.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/reparacion.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/shared/services/database_service.dart';
import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'package:bridgecare/shared/widgets/queue_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionFormScreen extends StatefulWidget {
  final int puenteId;

  const InspectionFormScreen({super.key, required this.puenteId});

  @override
  InspectionFormScreenState createState() => InspectionFormScreenState();
}

class InspectionFormScreenState extends State<InspectionFormScreen> {
  String? inspectorName;
  List<Map<String, String>> componentList = [];
  Map<String, dynamic>? puenteData;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('inspector_name') ?? 'Inspector Desconocido';
      final puenteData = await _fetchPuenteData(widget.puenteId);
      final componentsJson = await DefaultAssetBundle.of(context)
          .loadString('assets/data/inspection_components.json');
      final List<dynamic> components = jsonDecode(componentsJson);
      final componentList = components
          .map((item) => {
                'key': item['key'] as String,
                'title': item['title'] as String,
              })
          .toList();

      setState(() {
        inspectorName = name;
        this.componentList = componentList;
        this.puenteData = puenteData;
        isDataLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() {
          isDataLoaded = true; // Allow rendering with error state
        });
      }
    }
  }

  Future<Map<String, dynamic>> _fetchPuenteData(int puenteId) async {
    return Future.value({
      'nombre': 'Puente Ejemplo',
      'identif': 'P001',
      'carretera': '123',
      'pr': 'PR 45',
      'regional': 'Region Central',
    });
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

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded ||
        puenteData == null ||
        componentList.isEmpty ||
        inspectorName == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => InspectionController(
        puenteId: widget.puenteId,
        componentList: componentList,
        databaseService: DatabaseService(),
        queueService: QueueService(),
      )..setPuenteData(puenteData!),
      child: Consumer<InspectionController>(
        builder: (context, controller, _) {
          return Stack(
            children: [
              Scaffold(
                body: FormTemplate(
                  title: 'Formulario de Inspección',
                  formKey: controller.formKey,
                  onSave: () async {
                    try {
                      await controller.submitForm();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Inspección en cola para sincronización')),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
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
                            initialData: puenteData!,
                            onSave: (data) => controller.updatePuenteData(data),
                          ),
                          DynamicForm(
                            fields: Inspeccion.formFields,
                            initialData: controller.inspeccion.toJson(),
                            onSave: (data) =>
                                controller.updateInspeccionData(data),
                          ),
                          TextFormField(
                            initialValue: inspectorName,
                            decoration:
                                const InputDecoration(labelText: 'Inspector'),
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
                              },
                              initialData: controller
                                  .inspeccion.componentes[index]
                                  .toJson(),
                              onSave: (data) =>
                                  controller.updateComponenteData(index, data),
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
                              initialData: controller
                                      .inspeccion.componentes[index].reparacion
                                      ?.toJson() ??
                                  {},
                              onSave: (data) =>
                                  controller.updateReparacionData(index, data),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (controller.isWidgetVisible)
                QueueProgressWidget(
                  queueService: controller.queueService,
                  onHide: controller.hideWidget,
                  onTap: () async {
                    await controller.queueService.retryFailedTasks();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
