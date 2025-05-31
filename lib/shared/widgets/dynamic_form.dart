import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DynamicForm extends StatefulWidget {
  final Map<String, dynamic> fields;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? extraData;
  final Map<String, TextEditingController>? controllers;

  const DynamicForm({
    super.key,
    required this.fields,
    required this.initialData,
    required this.onSave,
    this.extraData,
    this.controllers,
  });

  @override
  DynamicFormState createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm>
    with AutomaticKeepAliveClientMixin {
  final Map<String, dynamic> _formData = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _formData.addAll(widget.initialData!);
    }
    widget.fields.forEach((key, fieldInfo) {
      if (fieldInfo['type'] == 'text' || fieldInfo['type'] == 'number') {
        if (widget.controllers != null && widget.controllers![key] != null) {
          _controllers[key] = widget.controllers![key]!;
          if (_controllers[key]!.text.isEmpty && _formData[key] != null) {
            _controllers[key]!.text = _formData[key]!.toString();
          }
        } else {
          _controllers[key] =
              TextEditingController(text: _formData[key]?.toString());
        }

        _controllers[key]!.addListener(() {
          _formData[key] = _controllers[key]!.text.isNotEmpty
              ? (fieldInfo['type'] == 'number'
                  ? double.tryParse(_controllers[key]!.text)
                  : _controllers[key]!.text)
              : null;
          widget.onSave(_formData);
        });
      } else if (fieldInfo['type'] == 'image') {
        _formData[key] ??= <XFile>[];
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      if (widget.controllers == null || widget.controllers![key] == null) {
        controller.dispose();
      }
    });
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
          content: Text('Por favor completa todos los campos obligatorios'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }

    return true;
  }

  InputDecoration _getInputDecoration(String label, {bool readOnly = false}) {
    return InputDecoration(
      labelText: label,
      filled: readOnly,
      fillColor: readOnly ? Colors.grey[300] : Colors.transparent,
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
        final isReadOnly = fieldInfo['readOnly'] == true;
        field = TextFormField(
          controller: _controllers[fieldName],
          decoration:
              _getInputDecoration(fieldInfo['label'], readOnly: isReadOnly),
          enabled: !isReadOnly,
          readOnly: isReadOnly,
          enableInteractiveSelection: !isReadOnly,
          style: isReadOnly ? TextStyle(color: Colors.grey[700]) : null,
          onSaved: (value) => _formData[fieldName] = value,
        );
        break;
      case 'textarea':
        final isReadOnly = fieldInfo['readOnly'] == true;
        field = TextFormField(
          controller: _controllers[fieldName],
          decoration:
              _getInputDecoration(fieldInfo['label'], readOnly: isReadOnly),
          readOnly: isReadOnly,
          enabled: !isReadOnly,
          maxLines: 5,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          onSaved: (value) => _formData[fieldName] = value,
        );
        break;
      case 'number':
        field = TextFormField(
          controller: _controllers[fieldName],
          decoration: _getInputDecoration(fieldInfo['label']),
          readOnly: fieldInfo['readOnly'] == true,
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
          final value = _formData[fieldName];
          if (value is DateTime) {
            _controllers[fieldName]!.text =
                value.toIso8601String().split('T')[0];
          } else if (value is String) {
            final parsed = DateTime.tryParse(value);
            if (parsed != null) {
              _formData[fieldName] = parsed;
              _controllers[fieldName]!.text =
                  parsed.toIso8601String().split('T')[0];
            }
          }
        } else if (initialValue != null &&
            _controllers[fieldName]!.text.isEmpty) {
          if (initialValue is DateTime) {
            _controllers[fieldName]!.text =
                initialValue.toIso8601String().split('T')[0];
          } else if (initialValue is String) {
            final parsedDate = DateTime.tryParse(initialValue);
            if (parsedDate != null) {
              _controllers[fieldName]!.text =
                  parsedDate.toIso8601String().split('T')[0];
              _formData[fieldName] = parsedDate;
            }
          }
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
        List<XFile> selectedImages = _formData[fieldName] is List<XFile>
            ? _formData[fieldName] as List<XFile>
            : [];
        field = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldInfo['label'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...selectedImages.map((image) => Stack(
                      children: [
                        Image.file(
                          File(image.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedImages.remove(image);
                                _formData[fieldName] = selectedImages;
                                widget.onSave(_formData);
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera); // Or ImageSource.gallery
                    if (image != null) {
                      setState(() {
                        selectedImages.add(image);
                        _formData[fieldName] = selectedImages;
                        widget.onSave(_formData);
                      });
                    }
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add Image'),
                ),
              ],
            ),
          ],
        );
        break;
      default:
        field = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: field,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.entries
          .map((entry) => _buildField(entry.key, entry.value))
          .toList(),
    );
  }
}
