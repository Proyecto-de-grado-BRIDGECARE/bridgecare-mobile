import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ManualPdfViewerPage extends StatefulWidget {
  const ManualPdfViewerPage({super.key});

  @override
  State<ManualPdfViewerPage> createState() => _ManualPdfViewerPageState();
}

class _ManualPdfViewerPageState extends State<ManualPdfViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    final byteData = await rootBundle.load('assets/pdfs/manual.pdf');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/manual.pdf');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual de Usuario')),
      body: localPath != null
          ? PDFView(filePath: localPath!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
