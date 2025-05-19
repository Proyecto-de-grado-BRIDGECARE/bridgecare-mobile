import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.6:8084/api/images/upload';
  static const String inspectionUrl = 'http://192.168.1.6:8083/api/inspeccion';
  static const String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJicmlkZ2VjYXJlcHVqQGdtYWlsLmNvbSIsImlhdCI6MTc0NTE5NTU1NH0.xXw_Cu5QAC3vsSfqnVHw4N_9zwRl6qCnRtw4oy8veXY';

  Future<void> initiateImageUpload(
    String imageId,
    int totalChunks,
    String filename,
    int bridgeId,
    String inspectionId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/initiate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'imageId': imageId,
        'totalChunks': totalChunks,
        'filename': filename,
        'bridgeId': bridgeId,
        'inspectionId': inspectionId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to initiate upload: ${response.statusCode} ${response.body}');
    }
  }

  Future<http.Response> uploadImageChunk(
    String imageId,
    int chunkIndex,
    List<int> data,
    int bridgeId,
    String inspectionId,
  ) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/chunk'))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['imageId'] = imageId
      ..fields['chunkIndex'] = chunkIndex.toString()
      ..fields['bridgeId'] = bridgeId.toString()
      ..fields['inspectionId'] = inspectionId
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          data,
          filename: 'chunk_$chunkIndex',
        ),
      );
    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);
    return responseBody;
  }

  Future<String> completeImageUpload(
    String imageId,
    String filename,
    int bridgeId,
    String inspectionId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/complete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'imageId': imageId,
        'filename': filename,
        'bridgeId': bridgeId,
        'inspectionId': inspectionId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to complete upload: ${response.statusCode} ${response.body}');
    }
    return response.body; // Return raw URL
  }

  Future<http.Response> uploadInspectionJson(
    Map<String, dynamic> json,
    int bridgeId,
    String inspectionId,
  ) async {
    json['puenteId'] = bridgeId;
    json['inspectionId'] = inspectionId;
    final response = await http.post(
      Uri.parse('$inspectionUrl/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(json),
    );
    return response;
  }
}
