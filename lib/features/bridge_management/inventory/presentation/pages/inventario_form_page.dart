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
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bridgecare/features/bridge_management/services/location_service.dart';
import '../../../../../shared/help_loader.dart';
import '../../../../../shared/widgets/help_icon_button.dart';
import '../../models/dtos/inventario_dto.dart';

class InventoryFormScreen extends StatefulWidget {
  final int usuarioId;
  final InventarioDTO? inventario;

  const InventoryFormScreen({
    required this.usuarioId,
    this.inventario, // <- opcional: null si es crear
    super.key,
  });

  @override
  InventoryFormScreenState createState() => InventoryFormScreenState();
}

class InventoryFormScreenState extends State<InventoryFormScreen> {
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _altitudController = TextEditingController();
  Future<Map<String, HelpInfo>>? helpSectionsFuture;
  Map<String, HelpInfo> helpSections = {};
  bool get esEdicion => widget.inventario != null;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, HelpInfo>>(
      future: helpSectionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error cargando ayuda'));
        } else {
          helpSections = snapshot.data!;
          return FormTemplate(
            title: 'Creación de Inventario',
            formKey: _formKey,
            onSave: _saveForm,
            sections: _buildFormSections(), // lo vemos en el siguiente paso
          );
        }
      },
    );

  }
  @override
  void initState() {
    super.initState();
    debugPrint("📥 InventoryFormScreen iniciado con inventario: ${widget.inventario?.toMap()}");
    helpSectionsFuture = loadHelpSections();
    helpSectionsFuture!.then((loadedSections) {
      setState(() {
        helpSections = loadedSections;
      });
    });

    if (widget.inventario != null) {
      final inventario = widget.inventario!;
      _formData['observaciones'] = inventario.observaciones;
      _formData['puente'] = {'id': inventario.puente.id};
      _formData['pasos'] = inventario.pasos.map((p) => p.toJson()).toList();
      _formData['datos_administrativos'] = inventario.datosAdministrativos?.toJson() ?? {};
      _formData['datos_tecnicos'] = inventario.datosTecnicos?.toJson() ?? {};
      _formData['superestructuras'] = inventario.superestructuras.map((s) => s.toJson()).toList();
      _formData['subestructura'] = inventario.subestructura?.toJson() ?? {};
      _formData['apoyo'] = inventario.apoyo?.toJson() ?? {};
      _formData['miembros_interesados'] = inventario.miembrosInteresados?.toJson() ?? {};
      _formData['posicion_geografica'] = inventario.posicionGeografica?.toJson() ?? {};
      _formData['carga'] = inventario.carga?.toJson() ?? {};
    }
  }

  List<FormSection> _buildFormSections() {
    return [
      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Información Básica',
          trailing: HelpIconButton(
            helpKey: 'informacionBasica',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: DynamicForm(
          key: _puenteFormKey,
          fields: Puente.formFields,
          initialData: _formData['puente'],
          onSave: (data) => setState(() => _formData['puente']!.addAll(data)),
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Pasos',
          trailing: HelpIconButton(
            helpKey: 'pasos',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paso 1', style: TextStyle(fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Paso.formFields,
              initialData: _formData['pasos'][0],
              onSave: (data) => setState(() => _formData['pasos'][0].addAll(data)),
            ),
            const SizedBox(height: 16),
            const Text('Paso 2', style: TextStyle(fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Paso.formFields,
              initialData: _formData['pasos'][1],
              onSave: (data) => setState(() => _formData['pasos'][1].addAll(data)),
            ),
          ],
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Datos Administrativos',
          trailing: HelpIconButton(
            helpKey: 'datosAdministrativos',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: DynamicForm(
          fields: DatosAdministrativos.formFields,
          initialData: _formData['datos_administrativos'],
          onSave: (data) => setState(() => _formData['datos_administrativos']!.addAll(data)),
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Datos Técnicos',
          trailing: HelpIconButton(
            helpKey: 'datosTecnicos',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: DynamicForm(
          fields: DatosTecnicos.formFields,
          initialData: _formData['datos_tecnicos'],
          onSave: (data) => setState(() => _formData['datos_tecnicos']!.addAll(data)),
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Superestructura',
          trailing: HelpIconButton(
            helpKey: 'superestructura',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Principal', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Superestructura.formFields,
              initialData: _formData['superestructuras'][0],
              onSave: (data) => setState(() => _formData['superestructuras'][0].addAll(data)),
            ),
            const SizedBox(height: 16.0),
            const Text('Secundario', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Superestructura.formFields,
              initialData: _formData['superestructuras'][1],
              onSave: (data) => setState(() => _formData['superestructuras'][1].addAll(data)),
            ),
          ],
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Subestructura',
          trailing: HelpIconButton(
            helpKey: 'subestructura',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estribos', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Estribo.formFields,
              initialData: _formData['subestructura']['estribos'],
              onSave: (data) => setState(() => _formData['subestructura']['estribos'].addAll(data)),
            ),
            const SizedBox(height: 16.0),
            const Text('Detalles', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Detalle.formFields,
              initialData: _formData['subestructura']['detalles'],
              onSave: (data) => setState(() => _formData['subestructura']['detalles'].addAll(data)),
            ),
            const SizedBox(height: 16.0),
            const Text('Pilas', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Pila.formFields,
              initialData: _formData['subestructura']['pilas'],
              onSave: (data) => setState(() => _formData['subestructura']['pilas'].addAll(data)),
            ),
            const SizedBox(height: 16.0),
            const Text('Señales', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DynamicForm(
              fields: Senial.formFields,
              initialData: _formData['subestructura']['seniales'],
              onSave: (data) => setState(() => _formData['subestructura']['seniales'].addAll(data)),
            ),
          ],
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Apoyo',
          trailing: HelpIconButton(
            helpKey: 'apoyo',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: DynamicForm(
          fields: Apoyo.formFields,
          initialData: _formData['apoyo'],
          onSave: (data) => setState(() => _formData['apoyo']!.addAll(data)),
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Miembros Interesados',
          trailing: HelpIconButton(
            helpKey: 'miembrosInteresados',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: DynamicForm(
          fields: MiembrosInteresados.formFields,
          initialData: _formData['miembros_interesados'],
          onSave: (data) => setState(() => _formData['miembros_interesados']!.addAll(data)),
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Posición Geográfica',
          trailing: HelpIconButton(
            helpKey: 'posicionGeografica',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener ubicación actual'),
                onPressed: _obtenerUbicacion,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xD040A4FF)),
              ),
            ),
            const SizedBox(height: 8.0),
            DynamicForm(
              key: ValueKey(_formData['posicion_geografica']),
              fields: PosicionGeografica.formFields,
              initialData: _formData['posicion_geografica'],
              controllers: {
                'latitud': _latitudController,
                'longitud': _longitudController,
                'altitud': _altitudController,
              },
              onSave: (data) => setState(() => _formData['posicion_geografica']!.addAll(data)),
            ),
          ],
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Carga',
          trailing: HelpIconButton(
            helpKey: 'carga',
            helpSections: helpSections,
          ),
        ),
        isCollapsible: true,
        content: DynamicForm(
          fields: Carga.formFields,
          initialData: _formData['carga'],
          onSave: (data) => setState(() => _formData['carga']!.addAll(data)),
        ),
      ),

      FormSection(
        titleWidget: DefaultSectionTitle(
          text: 'Observaciones',
        ),
        isCollapsible: false,
        content: DynamicForm(
          fields: Inventario.formFields,
          initialData: {'observaciones': _formData['observaciones']},
          onSave: (data) => setState(() => _formData['observaciones'] = data['observaciones'] ?? ''),
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
      )


    ];
  }


  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'observaciones': '',
    'puente': <String, dynamic>{'id': null},
    'usuario': <String, dynamic>{'id': null},
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
      'estribos': <String, dynamic>{},
      'pilas': <String, dynamic>{},
      'detalles': <String, dynamic>{},
      'seniales': <String, dynamic>{},
    },
    'apoyo': <String, dynamic>{},
    'miembros_interesados': <String, dynamic>{},
    'posicion_geografica': <String, dynamic>{},
    'carga': <String, dynamic>{},
  };

  final GlobalKey<DynamicFormState> _puenteFormKey = GlobalKey<DynamicFormState>();

  Future<void> _saveForm() async {
    //Validar campos requeridos del formulario del puente
    if (!_puenteFormKey.currentState!.validateForm()) {
      return; //No continuar si faltan campos requeridos
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        // Retrieve token from SharedPreferences
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
          _formData['usuario']['id'] = userId;
        } else {
          debugPrint("No se encontró usuario_id en SharedPreferences");
          return;
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
                  removeEmpty(
                      obj[i] as Map<String, dynamic>, defaultKey: defaultKey);
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

          if (cleaned['posicion_geografica'] != null && cleaned['posicion_geografica'].isNotEmpty) {
            convertYesNo(cleaned['posicion_geografica'], 'pasoCauce');
            convertYesNo(cleaned['posicion_geografica'], 'existeVariante');
          }

          if (cleaned['datos_tecnicos'] != null && cleaned['datos_tecnicos'].isNotEmpty) {
            convertYesNo(cleaned['datos_tecnicos'], 'puenteTerraplen');
          }

          if (cleaned['puente'] != null && cleaned['puente'].isNotEmpty) {
            final puenteFields = ['regional'];
            _parseFields(cleaned['puente'], puenteFields);
          }
          if (cleaned['apoyo'] != null && cleaned['apoyo'].isNotEmpty){
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
          if (cleaned['subestructura']?['estribos'] != null &&
              cleaned['subestructura']['estribos'].isNotEmpty) {
            final estriboFields = ['tipo', 'material', 'tipoCimentacion'];
            _parseFields(cleaned['subestructura']['estribos'], estriboFields);
          }
          if (cleaned['subestructura']?['pilas'] != null &&
              cleaned['subestructura']['pilas'].isNotEmpty){
            final pilaFields = ['tipo', 'material', 'tipoCimentacion'];
            _parseFields(cleaned['subestructura']['pilas'], pilaFields);
          }
          if (cleaned['subestructura']?['detalles'] != null &&
              cleaned['subestructura']['detalles'].isNotEmpty){
            final detalleFields = [
              'tipoBaranda',
              'superficieRodadura',
              'juntaExpansion'
            ];
            _parseFields(cleaned['subestructura']['detalles'], detalleFields);
          }

          removeEmpty(cleaned);

          return cleaned;
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

        debugPrint(jsonString);


        // Send to backend
        final url = esEdicion
            ? Uri.parse('http://192.168.1.9:8082/api/inventario/update/${widget.inventario!.id}')
            : Uri.parse('https://api.bridgecare.com.co/inventario/add');

        final response = await (esEdicion
            ? http.put(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonString,
        )
            : http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonString,
        ));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          int? puenteId;
          int? usuarioId;

          if (responseData is Map) {
            puenteId = responseData['puente']?['id'];
            usuarioId = responseData['usuario']?['id'];
          } else if (responseData is int) {
            puenteId = responseData;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(esEdicion
                  ? 'Inventario actualizado'
                  : 'Inventario creado'),
            ),
          );

          if (puenteId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InspectionFormScreen(puenteId: puenteId!),
              ),
            );
          }

          debugPrint("✅ Inventario procesado con puenteId: $puenteId y usuarioId: $usuarioId");
        } else {
          debugPrint("❌ Error al guardar inventario: ${response.statusCode}");
        }

        debugPrint(
          response.statusCode == 200 || response.statusCode == 201
              ? 'Success: ${response.body}'
              : 'Failed: ${response.statusCode} - ${response.body}',
        );

      }
    }

  }
  Future<void> _obtenerUbicacion() async {
    final posicion = await LocationService.obtenerPosicion();
    if (posicion != null) {
      setState(() {
        _latitudController.text = posicion.latitude.toStringAsFixed(6);
        _longitudController.text = posicion.longitude.toStringAsFixed(6);
        _altitudController.text = posicion.altitude.toStringAsFixed(2);

        _formData['posicion_geografica'] ??= {};
        _formData['posicion_geografica']['latitud'] = posicion.latitude;
        _formData['posicion_geografica']['longitud'] = posicion.longitude;
        _formData['posicion_geografica']['altitud'] = posicion.altitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ubicación obtenida correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la ubicación')),
      );
    }
  }
}