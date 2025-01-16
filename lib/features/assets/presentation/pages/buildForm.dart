import 'package:flutter/material.dart';

class _buildForm extends StatelessWidget {
  const _buildForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ...children
          ],
        ));
  }
}
