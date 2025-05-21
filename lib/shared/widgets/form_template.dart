import 'package:flutter/material.dart';

class FormSection {
  final String title;
  final bool isCollapsible;
  final Widget content;

  FormSection({
    required this.title,
    required this.isCollapsible,
    required this.content,
  });
}

class FormTemplate extends StatelessWidget {
  final String title;
  final List<FormSection> sections;
  final VoidCallback onSave;
  final GlobalKey<FormState> formKey;

  const FormTemplate({
    super.key,
    required this.title,
    required this.sections,
    required this.onSave,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color(0xff1780cc),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20), // top controla la altura
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ),
      ),



      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.asMap().entries.map((entry) {
              final section = entry.value;
              final isLast = entry.key == sections.length - 1;

              final content = section.content;

              if (section.isCollapsible) {
                final screenWidth = MediaQuery.of(context).size.width;

                return Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        section.title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // 🔁 entre 16 y 20 aprox según el ancho
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: content,
                        ),
                      ],
                    ),
                    if (!isLast)
                      const SizedBox(height: 16.0), // Gap between sections
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    content,
                    if (!isLast)
                      const SizedBox(height: 16.0), // Gap between sections
                  ],
                );
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}
