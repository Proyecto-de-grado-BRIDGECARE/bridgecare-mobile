import 'package:flutter/material.dart';

class DynamicForm extends StatefulWidget {
  final Map<String, dynamic> fields;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const DynamicForm({
    super.key,
    required this.fields,
    this.initialData,
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
                widget.onSave(_formData); // Update parent form data
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
                  widget.onSave(_formData); // Update parent form data
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
        field = GestureDetector(
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
                widget.onSave(_formData); // Update parent form data
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 20.0, color: Colors.blueGrey[700]),
                const SizedBox(width: 8.0),
                Text(
                  _formData[fieldName]?.toString() ??
                      initialValue?.toString() ??
                      fieldInfo['label'],
                  style: TextStyle(color: Colors.blueGrey[700]),
                ),
              ],
            ),
          ),
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.entries
          .map((entry) => _buildField(entry.key, entry.value))
          .toList(),
    );
  }
}
