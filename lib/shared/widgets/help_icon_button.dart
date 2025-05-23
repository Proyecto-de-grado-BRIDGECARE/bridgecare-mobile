import 'package:flutter/material.dart';
import '../help_loader.dart';
import 'help_dialog.dart';

class HelpIconButton extends StatelessWidget {
  final String helpKey;
  final Map<String, HelpInfo> helpSections;

  const HelpIconButton({
    super.key,
    required this.helpKey,
    required this.helpSections,
  });

  @override
  Widget build(BuildContext context) {
    final helpInfo = helpSections[helpKey];

    return IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.lightBlue),
      tooltip: 'Ver ayuda',
      onPressed: helpInfo != null
          ? () => showHelpDialog(context, helpInfo)
          : null,
    );
  }
}
