import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HelpInfo {
  final String title;
  final String content;
  final String? imageAsset;

  HelpInfo({
    required this.title,
    required this.content,
    this.imageAsset,
  });

  factory HelpInfo.fromJson(Map<String, dynamic> json) {
    return HelpInfo(
      title: json['title'] as String,
      content: json['content'] as String,
      imageAsset: json['imageAsset'] as String?,
    );
  }
}

Future<Map<String, HelpInfo>> loadHelpSections() async {
  final String jsonString = await rootBundle.loadString('assets/help/help_content.json');

  // ✅ Cast correcto y explícito al principio
  final Map<String, dynamic> rawMap = Map<String, dynamic>.from(json.decode(jsonString));

  final Map<String, HelpInfo> helpMap = {};
  rawMap.forEach((key, value) {
    // ⚠️ Asegurar que cada value también es Map<String, dynamic>
    if (value is Map<String, dynamic>) {
      helpMap[key] = HelpInfo.fromJson(value);
    } else if (value is Map) {
      helpMap[key] = HelpInfo.fromJson(Map<String, dynamic>.from(value));
    } else {
      debugPrint("⚠️ Entrada inválida ignorada: $key");
    }
  });

  return helpMap;
}




