import 'dart:convert';
import 'package:flutter/services.dart';

class HelpInfo {
  final String title;
  final String content;
  final String? imageAsset;

  HelpInfo({required this.title, required this.content, this.imageAsset});

  factory HelpInfo.fromJson(Map<String, dynamic> json) {
    return HelpInfo(
      title: json['title'],
      content: json['content'],
      imageAsset: json['imageAsset'],
    );
  }
}

Future<Map<String, HelpInfo>> loadHelpSections() async {
  final String jsonString = await rootBundle.loadString('assets/help/help_content.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  return jsonMap.map((key, value) => MapEntry(key, HelpInfo.fromJson(value)));
}
