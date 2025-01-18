import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class buildForm extends StatelessWidget {
  final String titulo;
  final List<Widget> campos;

  const buildForm({required this.campos, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          ...campos
        ],
      ),
    );
  }
}
