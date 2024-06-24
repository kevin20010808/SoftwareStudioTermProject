// services/image_analysis_service.dart
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:term_project/models/my_record.dart';

class ImageAnalysisService {
  final String apiBaseUrl ='https://api.openai.com/v1/chat/completions';
  final String apiKey = '';

  Future<MyRecord?> analyzeImageAndGetRecord(String imageUrl, String itemId) async {
    Uint8List imageBytes = await _downloadImage(imageUrl);
    Uint8List compressedImageBytes = await _compressImage(imageBytes);
    String base64Image = base64Encode(compressedImageBytes);

    var url = Uri.parse(apiBaseUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-2024-05-13',
        'messages': [
          {
            'role': 'system',
            'content': 'Analyze and approximate the food in the following image. Provide its name, weight, calories, protein, fat, and carbs as a JSON object. Do not return other information!'
          },
          {
            'role': 'user',
            'content': base64Image
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String content = data['choices'][0]['message']['content'];
      content = content.replaceAll('```json', '').replaceAll('```', '').trim();
      var nutritionData = jsonDecode(content);

      var record = MyRecord(
        id: int.parse(itemId),
        foodName: nutritionData['name'],
        foodImage: imageUrl,
        weight: 'Weight: ${nutritionData['weight']}',
        calories: 'Calories: ${nutritionData['calories']}',
        protein: 'Protein: ${nutritionData['protein']}',
        fat: 'Fat: ${nutritionData['fat']}',
        carbs: 'Carbs: ${nutritionData['carbs']}',
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      print('Record: $record');
      return record;
    } else {
      print('Failed to analyze image: ${response.body}');
    }

    return null;
  }

  Future<Uint8List> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image');
    }
  }

  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    img.Image image = img.decodeImage(imageBytes)!;
    img.Image resizedImage = img.copyResize(image, width: 300);
    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));
  }
}