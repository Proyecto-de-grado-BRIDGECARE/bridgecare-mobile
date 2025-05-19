import 'dart:io';
import 'dart:typed_data';
import 'package:bridgecare/config/constants.dart';
import 'package:bridgecare/features/bridge_management/inspection/models/models.dart'
    as models;
import 'package:bridgecare/shared/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'database_service.dart';

class ImageHandler {
  final DatabaseService _dbService = DatabaseService();
  final ImagePicker _picker = ImagePicker();

  Future<models.ImageData?> captureAndUploadImage(
    String inspeccionUuid,
    String componenteUuid,
    String puenteId,
  ) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return null;

      final String imageUuid = const Uuid().v4();
      final String localPath = await _saveImageLocally(photo);
      final String createdAt = DateTime.now().toIso8601String();

      final File imageFile = File(localPath);
      final int fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        // 10MB limit
        throw Exception('Image size exceeds 10MB');
      }
      final int chunkSize = Constants.chunkSize;
      final int chunkCount = (fileSize / chunkSize).ceil();

      final models.ImageData imageData = models.ImageData(
        inspeccionUuid: inspeccionUuid,
        componenteUuid: componenteUuid,
        imageUuid: imageUuid,
        puenteId: puenteId,
        localPath: localPath,
        createdAt: createdAt,
        chunkCount: chunkCount,
        chunksUploaded: 0,
        uploadStatus: 'pending',
      );

      await _dbService.insertImage(imageData);

      for (int i = 0; i < chunkCount; i++) {
        final taskData = jsonEncode({
          'image_uuid': imageUuid,
          'chunk_index': i,
          'total_chunks': chunkCount,
          'local_path': localPath,
          'puente_id': puenteId,
          'inspeccion_uuid': inspeccionUuid,
          'componente_uuid': componenteUuid,
        });
        await _dbService.enqueueTask(taskType: 'image_chunk', data: taskData);
      }

      return imageData;
    } catch (e) {
      Utils.logError('Image capture/queue failed: $e');
      return null;
    }
  }

  Future<String> _saveImageLocally(XFile photo) async {
    final directory = await getTemporaryDirectory();
    final String fileName = '${const Uuid().v4()}.jpg';
    final String localPath = '${directory.path}/$fileName';
    final File imageFile = File(localPath);

    final List<int> imageBytes = await photo.readAsBytes();
    final Uint8List uint8ImageBytes = Uint8List.fromList(imageBytes);
    final img.Image? decodedImage = img.decodeImage(uint8ImageBytes);
    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }

    final List<int> jpegBytes = img.encodeJpg(decodedImage, quality: 80);
    await imageFile.writeAsBytes(jpegBytes);

    return localPath;
  }
}
