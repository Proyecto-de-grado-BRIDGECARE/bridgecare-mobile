import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DynamicForm extends StatefulWidget {
  final Map<String, dynamic> fields;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const DynamicForm({
    super.key,
    required this.fields,
    required this.initialData,
    required this.onSave,
  });

  @override
  DynamicFormState createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm>
    with AutomaticKeepAliveClientMixin {
  final Map<String, dynamic> _formData = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  bool get wantKeepAlive => true; // Keep state alive

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _formData.addAll(widget.initialData!);
    }
    // Initialize controllers for text and number fields
    widget.fields.forEach((key, fieldInfo) {
      if (fieldInfo['type'] == 'text' || fieldInfo['type'] == 'number') {
        _controllers[key] =
            TextEditingController(text: _formData[key]?.toString());
        _controllers[key]!.addListener(() {
          _formData[key] = _controllers[key]!.text.isNotEmpty
              ? (fieldInfo['type'] == 'number'
                  ? double.tryParse(_controllers[key]!.text)
                  : _controllers[key]!.text)
              : null;
          widget.onSave(_formData); // Update parent form data in real-time
        });
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  bool validateForm() {
    final missingFields = widget.fields.entries.where((entry) {
      final key = entry.key;
      final fieldInfo = entry.value;
      final isRequired = fieldInfo['required'] == true;
      final value = _formData[key];

      if (!isRequired) return false;

      if (fieldInfo['type'] == 'image') {
        return value == null || (value is List && value.isEmpty);
      }

      if (fieldInfo['type'] == 'checkbox') {
        return value != true;
      }

      return value == null || (value is String && value.trim().isEmpty);
    });

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Por favor completa todos los campos obligatorios (nombre, identificador, carretera, regional)'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }

    return true;
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.blueGrey, width: 2.0),
      ),
      labelStyle: TextStyle(color: Colors.blueGrey[700]),
    );
  }

  Widget _buildField(String fieldName, Map<String, dynamic> fieldInfo) {
    final initialValue = widget.initialData?[fieldName];
    _controllers[fieldName] ??= TextEditingController();
    Widget field;

    switch (fieldInfo['type']) {
      case 'text':
        field = TextFormField(
          controller: _controllers[fieldName],
          decoration: _getInputDecoration(fieldInfo['label']),
          onSaved: (value) => _formData[fieldName] = value,
        );
        break;
      case 'number':
        field = TextFormField(
          controller: _controllers[fieldName],
          decoration: _getInputDecoration(fieldInfo['label']),
          keyboardType: TextInputType.number,
          onSaved: (value) => _formData[fieldName] =
              value != null && value.isNotEmpty
                  ? (fieldInfo['maxLength'] != null
                      ? int.parse(value)
                      : double.parse(value))
                  : null,
        );
        break;
      case 'dropdown':
        final options = fieldInfo['options'] as List<String>;
        final currentValue =
            _formData[fieldName]?.toString() ?? initialValue?.toString();
        final dropdownValue =
            options.contains(currentValue) ? currentValue : null;

        field = DropdownButtonFormField<String>(
          value: dropdownValue,
          decoration: _getInputDecoration(fieldInfo['label']),
          isExpanded: true,
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                _formData[fieldName] = value;
                widget.onSave(_formData);
              }
            });
          },
          onSaved: (value) => _formData[fieldName] = value,
        );
        break;
      case 'checkbox':
        field = Row(
          children: [
            Checkbox(
              value: _formData[fieldName] ?? initialValue ?? false,
              onChanged: (value) {
                setState(() {
                  _formData[fieldName] = value;
                  widget.onSave(_formData);
                });
              },
            ),
            const SizedBox(width: 8.0),
            Text(fieldInfo['label'],
                style: TextStyle(color: Colors.blueGrey[700])),
          ],
        );
        break;
      case 'date':
        if (_formData[fieldName] != null &&
            _controllers[fieldName]!.text.isEmpty) {
          _controllers[fieldName]!.text = (_formData[fieldName] as DateTime)
              .toIso8601String()
              .split('T')[0];
        } else if (initialValue != null &&
            _controllers[fieldName]!.text.isEmpty) {
          _controllers[fieldName]!.text =
              (initialValue as DateTime).toIso8601String().split('T')[0];
        }
        field = TextFormField(
          controller: _controllers[fieldName],
          decoration: _getInputDecoration(fieldInfo['label']).copyWith(
            prefixIcon: Icon(Icons.calendar_today,
                color: Colors.blueGrey[700], size: 20.0),
          ),
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                _formData[fieldName] = date;
                _controllers[fieldName]!.text =
                    date.toIso8601String().split('T')[0];
                widget.onSave(_formData);
              });
            }
          },
          onSaved: (value) => _formData[fieldName] = _formData[fieldName],
        );
        break;
      case 'image':
        // Initialize as empty list if not set
        _formData[fieldName] ??=
            initialValue ?? <XFile>[]; // Start with XFiles, later URLs
        final maxImages = fieldInfo['maxImages'] as int? ?? 5;
        final List<XFile> images = _formData[fieldName] as List<XFile>;

        field = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldInfo['label'],
                style: TextStyle(color: Colors.blueGrey[700])),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: images.map((image) {
                return Stack(
                  children: [
                    FutureBuilder<Uint8List>(
                      future: image.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              // Show larger image in a dialog
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.pop(context), // Close on tap
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit
                                          .contain, // Fit within screen bounds
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Image.memory(
                              snapshot.data!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            images.remove(image);
                            widget.onSave(_formData);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            if (images.length < maxImages)
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    preferredCameraDevice: CameraDevice.rear,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      images.add(pickedFile);
                      widget.onSave(_formData);
                    });
                  }
                },
                icon: Icon(Icons.add_a_photo),
                label: Text('Tomar Foto (${images.length}/$maxImages)'),
              ),
          ],
        );
        break;
      default:
        field = const SizedBox.shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8.0), // Should be 'bottom' or similar
      child: field,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.entries
          .map((entry) => _buildField(entry.key, entry.value))
          .toList(),
    );
  }
}
