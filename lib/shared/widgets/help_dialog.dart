import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../help_loader.dart';

void showHelpDialog(BuildContext context, HelpInfo helpInfo) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(helpInfo.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (helpInfo.imageAsset != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset(helpInfo.imageAsset!),
              ),
            MarkdownBody(data: helpInfo.content),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}
