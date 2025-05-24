import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ManualPdfViewerPage extends StatefulWidget {
  final int tipoUsuario; // 0, 1: Ingeniero; 2: Administrador

  const ManualPdfViewerPage({super.key, required this.tipoUsuario});

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
    final manualPath = widget.tipoUsuario == 2
        ? 'assets/help/ManualAdministrador.pdf'
        : 'assets/help/ManualIngeniero.pdf';

    final byteData = await rootBundle.load(manualPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/manual_temp.pdf');
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
