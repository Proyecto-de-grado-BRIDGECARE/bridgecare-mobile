import 'package:bridgecare/features/bridge_management/inventory/models/detalle.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/estribo.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/pila.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/senial.dart';
import 'package:bridgecare/shared/widgets/dynamic_form.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/apoyo.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/carga.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/datos_administrativos.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/datos_tecnicos.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/inventario.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/miembros_interesados.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/paso.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/posicion_geografica.dart';
import 'package:bridgecare/features/bridge_management/inventory/models/superestructura.dart';
import 'package:bridgecare/features/bridge_management/models/puente.dart';
import 'package:bridgecare/shared/widgets/form_template.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryFormScreen extends StatefulWidget {
  final int usuarioId;

  const InventoryFormScreen({required this.usuarioId, super.key});

  @override
  InventoryFormScreenState createState() => InventoryFormScreenState();
}

class InventoryFormScreenState extends State<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Map<String, dynamic>> _formData = {
    'puente': {},
    'inventario': {},
    'paso1': {'numero': 1},
    'galibo1': {}, // Unused but kept for now
    'paso2': {'numero': 2},
    'galibo2': {}, // Unused but kept for now
    'datos_administrativos': {},
    'datos_tecnicos': {},
    'superestructura_principal': {'tipo': 1},
    'superestructura_secundario': {'tipo': 2},
    'subestructura': {},
    'estribos': {},
    'pilas': {},
    'detalles': {},
    'senales': {},
    'apoyo': {},
    'miembros_interesados': {},
    'posicion_geografica': {},
    'carga': {},
  };

  int? _parseDropdownValue(String? value) {
    if (value == null) return null;
    final match = RegExp(r'^(\d+)\s*-').firstMatch(value);
    return match != null ? int.parse(match.group(1)!) : null;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Post Puente
        final puenteResponse = await http.post(
          Uri.parse('https://your-api.com/puentes'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(_formData['puente']),
        );
        if (puenteResponse.statusCode != 201) {
          throw Exception('Failed to create Puente: ${puenteResponse.body}');
        }
        final puenteData = jsonDecode(puenteResponse.body);
        final puenteId = puenteData['id'] as int;

        // Post Paso 1
        _formData['paso1']!['puenteId'] = puenteId;
        final paso1Data = Map<String, dynamic>.from(_formData['paso1']!);
        paso1Data['galiboI'] =
            _parseDropdownValue(paso1Data['galiboI']?.toString());
        paso1Data['galiboIm'] =
            _parseDropdownValue(paso1Data['galiboIm']?.toString());
        paso1Data['galiboDm'] =
            _parseDropdownValue(paso1Data['galiboDm']?.toString());
        paso1Data['galiboD'] =
            _parseDropdownValue(paso1Data['galiboD']?.toString());
        final paso1Response = await http.post(
          Uri.parse('https://your-api.com/pasos'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(paso1Data),
        );
        if (paso1Response.statusCode != 201) {
          throw Exception('Failed to create Paso 1: ${paso1Response.body}');
        }

        // Post Paso 2
        _formData['paso2']!['puenteId'] = puenteId;
        final paso2Data = Map<String, dynamic>.from(_formData['paso2']!);
        paso2Data['galiboI'] =
            _parseDropdownValue(paso2Data['galiboI']?.toString());
        paso2Data['galiboIm'] =
            _parseDropdownValue(paso2Data['galiboIm']?.toString());
        paso2Data['galiboDm'] =
            _parseDropdownValue(paso2Data['galiboDm']?.toString());
        paso2Data['galiboD'] =
            _parseDropdownValue(paso2Data['galiboD']?.toString());
        final paso2Response = await http.post(
          Uri.parse('https://your-api.com/pasos'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(paso2Data),
        );
        if (paso2Response.statusCode != 201) {
          throw Exception('Failed to create Paso 2: ${paso2Response.body}');
        }

        // Post Estribos
        final estribosData = Map<String, dynamic>.from(_formData['estribos']!);
        estribosData['material'] =
            _parseDropdownValue(estribosData['material']?.toString());
        estribosData['tipoCimentacion'] =
            _parseDropdownValue(estribosData['tipoCimentacion']?.toString());
        // Add subestructuraId if required by your API

        // Post Inventario
        _formData['inventario']!['puenteId'] = puenteId;
        _formData['inventario']!['usuarioId'] = widget.usuarioId;
        final inventarioResponse = await http.post(
          Uri.parse('https://your-api.com/inventarios'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(_formData['inventario']),
        );
        if (inventarioResponse.statusCode != 201) {
          throw Exception(
              'Failed to create Inventario: ${inventarioResponse.body}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formulario enviado con éxito')),
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
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Paso.formFields,
                initialData: _formData['paso1'],
                onSave: (data) =>
                    setState(() => _formData['paso1']!.addAll(data)),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Paso 2',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Paso.formFields,
                initialData: _formData['paso2'],
                onSave: (data) =>
                    setState(() => _formData['paso2']!.addAll(data)),
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
                () => _formData['datos_administrativos']!.addAll(data)),
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
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Superestructura.formFields,
                initialData: _formData['superestructura_principal'],
                onSave: (data) => setState(
                    () => _formData['superestructura_principal']!.addAll(data)),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Secundario',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Superestructura.formFields,
                initialData: _formData['superestructura_secundario'],
                onSave: (data) => setState(() =>
                    _formData['superestructura_secundario']!.addAll(data)),
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
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Estribo.formFields,
                initialData: _formData['estribos'],
                onSave: (data) =>
                    setState(() => _formData['estribos']!.addAll(data)),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Detalles',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Detalle.formFields,
                initialData: _formData['detalles'],
                onSave: (data) =>
                    setState(() => _formData['detalles']!.addAll(data)),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Pilas',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Pila.formFields,
                initialData: _formData['pilas'],
                onSave: (data) =>
                    setState(() => _formData['pilas']!.addAll(data)),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Señales',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              DynamicForm(
                fields: Senial.formFields,
                initialData: _formData['senales'],
                onSave: (data) =>
                    setState(() => _formData['senales']!.addAll(data)),
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
            onSave: (data) =>
                setState(() => _formData['miembros_interesados']!.addAll(data)),
          ),
        ),
        FormSection(
          title: 'Posición Geográfica',
          isCollapsible: true,
          content: DynamicForm(
            fields: PosicionGeografica.formFields,
            initialData: _formData['posicion_geografica'],
            onSave: (data) =>
                setState(() => _formData['posicion_geografica']!.addAll(data)),
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
            initialData: _formData['inventario'],
            onSave: (data) =>
                setState(() => _formData['inventario']!.addAll(data)),
          ),
        ),
      ],
    );
  }
}
