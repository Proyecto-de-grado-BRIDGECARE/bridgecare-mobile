import 'package:bridgecare/features/auth/services/auth_service.dart';
import 'package:bridgecare/features/bridge_management/inspection/presentation/pages/inspeccion_form_page.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/detalle.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/estribo.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/pila.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/senial.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/apoyo.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/carga.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/datos_administrativos.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/datos_tecnicos.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/inventario.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/miembros_interesados.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/paso.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/posicion_geografica.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/entities/superestructura.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryFormScreen extends StatefulWidget {
  const InventoryFormScreen({super.key});

  @override
  InventoryFormScreenState createState() => InventoryFormScreenState();
}

class InventoryFormScreenState extends State<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'observaciones': '',
    'puente': <String, dynamic>{'id': null},
    'usuario': <String, dynamic>{},
    'pasos': [
      <String, dynamic>{'numero': 1},
      <String, dynamic>{'numero': 2},
    ],
    'datos_administrativos': <String, dynamic>{},
    'datos_tecnicos': <String, dynamic>{},
    'superestructuras': [
      <String, dynamic>{'tipo': 1},
      <String, dynamic>{'tipo': 2},
    ],
    'subestructura': <String, dynamic>{
      'estribo': <String, dynamic>{},
      'pila': <String, dynamic>{},
      'detalle': <String, dynamic>{},
      'senial': <String, dynamic>{},
    },
    'apoyo': <String, dynamic>{},
    'miembros_interesados': <String, dynamic>{},
    'posicion_geografica': <String, dynamic>{},
    'carga': <String, dynamic>{},
  };

  @override
  void initState() {
    super.initState();
    _loadUserIntoFormData();
  }

  Future<void> _loadUserIntoFormData() async {
    final user = await AuthService().getUser();
    if (user != null) {
      setState(() {
        // Inject the entire user object into the 'usuario' key of _formData
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

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (token == null) {
        debugPrint('Error: No token found');
        return;
      }

      // Clean up _formData
      final cleanedData = _cleanFormData(_formData);
      final jsonEncoder = JsonEncoder.withIndent('  ', (obj) {
        if (obj is DateTime) {
          return obj.toIso8601String();
        }
        return obj; // Fallback to default encoding
      });
      final jsonString = jsonEncoder.convert(cleanedData);

      // Send to backend
      final url = Uri.parse('http://10.43.101.76:8082/api/inventario/add');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );

      // Check response and show popup
      if (response.statusCode == 200 && mounted) {
        // Parse the inventarioId from the response
        final inventarioId =
            int.parse(response.body); // Assuming it's returned as a string

        showDialog(
          context: context, // Pass the context
          builder: (ctx) => AlertDialog(
            title: const Text('Inventario creado exitosamente!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Pass the inventarioId to the InspectionFormScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InspectionFormScreen(puenteId: inventarioId),
                      ),
                    );
                  },
                  child: const Text('Crear Inspección'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Return to the previous screen (homepage)
                  },
                  child: const Text('Volver al menú principal'),
                ),
              ],
            ),
          ),
        );
      } else {
        debugPrint(
          'Failed: ${response.statusCode} - ${response.body}',
        );
      }
    }
  }

  Map<String, dynamic> _cleanFormData(Map<String, dynamic> data) {
    final cleaned = Map<String, dynamic>.from(data);

    void convertYesNo(Map<String, dynamic> map, String field) {
      if (map[field] is String) {
        map[field] = map[field] == 'Sí'
            ? true
            : map[field] == 'No'
                ? false
                : map[field];
      }
    }

    void trimStrings(dynamic obj) {
      if (obj is String) {
        obj = obj.trim();
      } else if (obj is Map) {
        obj.forEach((key, value) {
          if (value is String) {
            obj[key] = value.trim();
          } else if (value is Map || value is List) {
            trimStrings(value);
          }
        });
      } else if (obj is List) {
        for (var i = 0; i < obj.length; i++) {
          if (obj[i] is String) {
            obj[i] = obj[i].trim();
          } else if (obj[i] is Map || obj[i] is List) {
            trimStrings(obj[i]);
          }
        }
      }
    }

    bool isMinimalMap(Map<String, dynamic> map, String defaultKey) {
      if (map.length == 1 && map.containsKey(defaultKey)) {
        return true;
      }
      return false;
    }

    void removeEmpty(dynamic obj, {String? defaultKey}) {
      if (obj is Map<String, dynamic>) {
        obj.removeWhere((key, value) {
          if (value is Map) {
            removeEmpty(value as Map<String, dynamic>);
            return value.isEmpty;
          } else if (value is List) {
            removeEmpty(value, defaultKey: defaultKey);
            return value.isEmpty;
          }
          return false;
        });
      } else if (obj is List) {
        for (var i = 0; i < obj.length; i++) {
          if (obj[i] is Map) {
            removeEmpty(obj[i] as Map<String, dynamic>, defaultKey: defaultKey);
          } else {
            removeEmpty(obj[i], defaultKey: defaultKey);
          }
        }
        obj.removeWhere((item) =>
            item is Map &&
            (defaultKey != null
                ? isMinimalMap(item as Map<String, dynamic>, defaultKey)
                : item.isEmpty));
      }
    }

    trimStrings(cleaned);

    if (cleaned['pasos'] != null && cleaned['pasos'].isNotEmpty) {
      cleaned['pasos'] = cleaned['pasos']
          .where((paso) => !isMinimalMap(paso, 'numero'))
          .toList();
      if (cleaned['pasos'].isEmpty) {
        cleaned.remove('pasos');
      } else {
        for (var paso in cleaned['pasos']) {
          convertYesNo(paso, 'primero');
        }
      }
    }

    if (cleaned['superestructuras'] != null &&
        cleaned['superestructuras'].isNotEmpty) {
      cleaned['superestructuras'] = cleaned['superestructuras']
          .where((sup) => !isMinimalMap(sup, 'tipo'))
          .toList();
      if (cleaned['superestructuras'].isEmpty) {
        cleaned.remove('superestructuras');
      } else {
        for (var sup in cleaned['superestructuras']) {
          final superestructuraFields = [
            'tipoEstructuracionTransversal',
            'tipoEstructuracionLongitudinal',
            'material',
          ];
          _parseFields(sup, superestructuraFields);
          convertYesNo(sup, 'disenioTipo');
        }
      }
    }

    if (cleaned['posicion_geografica'] != null &&
        cleaned['posicion_geografica'].isNotEmpty) {
      convertYesNo(cleaned['posicion_geografica'], 'pasoCauce');
      convertYesNo(cleaned['posicion_geografica'], 'existeVariante');
    }
    if (cleaned['datos_tecnicos'] != null &&
        cleaned['datos_tecnicos'].isNotEmpty) {
      convertYesNo(cleaned['datos_tecnicos'], 'puenteTerraplen');
    }
    if (cleaned['puente'] != null && cleaned['puente'].isNotEmpty) {
      final puenteFields = ['regional'];
      _parseFields(cleaned['puente'], puenteFields);
    }
    if (cleaned['apoyo'] != null && cleaned['apoyo'].isNotEmpty) {
      final apoyoFields = [
        'fijoSobreEstribo',
        'movilSobreEstribo',
        'fijoEnPila',
        'movilEnPila',
        'fijoEnViga',
        'movilEnViga',
        'vehiculoDiseno',
        'claseDistribucionCarga',
      ];
      _parseFields(cleaned['apoyo'], apoyoFields);
    }

    if (cleaned['subestructura']['estribo'] != null &&
        cleaned['subestructura']['estribo'].isNotEmpty) {
      final estriboFields = ['tipo', 'material', 'tipoCimentacion'];
      _parseFields(cleaned['subestructura']['estribo'], estriboFields);
    }
    if (cleaned['subestructura']['pila'] != null &&
        cleaned['subestructura']['pila'].isNotEmpty) {
      final pilaFields = ['tipo', 'material', 'tipoCimentacion'];
      _parseFields(cleaned['subestructura']['pila'], pilaFields);
    }
    if (cleaned['subestructura']['detalle'] != null &&
        cleaned['subestructura']['detalle'].isNotEmpty) {
      final detalleFields = [
        'tipoBaranda',
        'superficieRodadura',
        'juntaExpansion'
      ];
      _parseFields(cleaned['subestructura']['detalle'], detalleFields);
    }

    removeEmpty(cleaned);

    return cleaned;
  }

  void _parseFields(Map<String, dynamic> data, List<String> fields) {
    for (var field in fields) {
      if (data[field] is String) {
        if (data[field].contains(' - ')) {
          data[field] = int.parse(data[field].split(' - ')[0]);
        } else {
          data[field] = double.tryParse(data[field]) ?? data[field];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      title: 'Formulario de Inventario',
      formKey: _formKey,
      onSave: _saveForm,
      sections: [
        FormSection(
          title: 'Información Básica',
          isCollapsible: true,
          content: DynamicForm(
            fields: Puente.formFields,
            initialData: _formData['puente'],
            onSave: (data) => setState(() => _formData['puente']!.addAll(data)),
          ),
        ),
        FormSection(
          title: 'Pasos',
          isCollapsible: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paso 1',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Paso.formFields,
                initialData: _formData['pasos'][0], // First Paso
                onSave: (data) =>
                    setState(() => _formData['pasos'][0].addAll(data)),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Paso 2',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Paso.formFields,
                initialData: _formData['pasos'][1], // Second Paso
                onSave: (data) =>
                    setState(() => _formData['pasos'][1].addAll(data)),
              ),
            ],
          ),
        ),
        FormSection(
          title: 'Datos Administrativos',
          isCollapsible: true,
          content: DynamicForm(
            fields: DatosAdministrativos.formFields,
            initialData: _formData['datos_administrativos'],
            onSave: (data) => setState(
              () => _formData['datos_administrativos']!.addAll(data),
            ),
          ),
        ),
        FormSection(
          title: 'Datos Técnicos',
          isCollapsible: true,
          content: DynamicForm(
            fields: DatosTecnicos.formFields,
            initialData: _formData['datos_tecnicos'],
            onSave: (data) =>
                setState(() => _formData['datos_tecnicos']!.addAll(data)),
          ),
        ),
        FormSection(
          title: 'Superestructura',
          isCollapsible: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Principal',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Superestructura.formFields,
                initialData: _formData['superestructuras'][0],
                onSave: (data) => setState(
                  () => _formData['superestructuras'][0]!.addAll(data),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Secundario',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Superestructura.formFields,
                initialData: _formData['superestructuras'][1],
                onSave: (data) => setState(
                  () => _formData['superestructuras'][1]!.addAll(data),
                ),
              ),
            ],
          ),
        ),
        FormSection(
          title: 'Subestructura',
          isCollapsible: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estribos',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Estribo.formFields,
                initialData: _formData['subestructura']['estribo'],
                onSave: (data) => setState(
                  () => _formData['subestructura']['estribo'].addAll(data),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Detalles',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Detalle.formFields,
                initialData: _formData['subestructura']['detalle'],
                onSave: (data) => setState(
                  () => _formData['subestructura']['detalle'].addAll(data),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Pilas',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Pila.formFields,
                initialData: _formData['subestructura']['pila'],
                onSave: (data) => setState(
                  () => _formData['subestructura']['pila'].addAll(data),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Señales',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              DynamicForm(
                fields: Senial.formFields,
                initialData: _formData['subestructura']['senial'],
                onSave: (data) => setState(
                  () => _formData['subestructura']['senial'].addAll(data),
                ),
              ),
            ],
          ),
        ),
        FormSection(
          title: 'Apoyo',
          isCollapsible: true,
          content: DynamicForm(
            fields: Apoyo.formFields,
            initialData: _formData['apoyo'],
            onSave: (data) => setState(() => _formData['apoyo']!.addAll(data)),
          ),
        ),
        FormSection(
          title: 'Miembros Interesados',
          isCollapsible: true,
          content: DynamicForm(
            fields: MiembrosInteresados.formFields,
            initialData: _formData['miembros_interesados'],
            onSave: (data) => setState(
              () => _formData['miembros_interesados']!.addAll(data),
            ),
          ),
        ),
        FormSection(
          title: 'Posición Geográfica',
          isCollapsible: true,
          content: DynamicForm(
            fields: PosicionGeografica.formFields,
            initialData: _formData['posicion_geografica'],
            onSave: (data) => setState(
              () => _formData['posicion_geografica']!.addAll(data),
            ),
          ),
        ),
        FormSection(
          title: 'Carga',
          isCollapsible: true,
          content: DynamicForm(
            fields: Carga.formFields,
            initialData: _formData['carga'],
            onSave: (data) => setState(() => _formData['carga']!.addAll(data)),
          ),
        ),
        FormSection(
          title: 'Observaciones',
          isCollapsible: false,
          content: DynamicForm(
            fields: Inventario.formFields,
            initialData: {'observaciones': _formData['observaciones']},
            onSave: (data) => setState(
                () => _formData['observaciones'] = data['observaciones'] ?? ''),
          ),
        ),
        FormSection(
          title: '',
          isCollapsible: false,
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
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
        ),
      ],
    );
  }
}
