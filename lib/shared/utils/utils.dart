import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<void> logError(String message) async {
    await logToFile('ERROR: $message');
    debugPrint('ERROR: $message');
  }

  static Future<void> logToFile(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/app_logs.txt');
      final timestamp = DateTime.now().toIso8601String();
      await file.writeAsString('$timestamp: $message\n', mode: FileMode.append);
    } catch (e) {
      debugPrint('Failed to write log to file: $e');
    }
  }
}
