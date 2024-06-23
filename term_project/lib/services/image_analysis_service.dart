// services/image_analysis_service.dart
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:term_project/models/my_record.dart';
import 'package:term_project/services/firestore_service.dart';

class ImageAnalysisService {
  final String apiBaseUrl ='https://api.openai.com/v1/chat/completions';
  final String apiKey = '';

  Future<MyRecord?> analyzeImageAndGetRecord(String imageUrl, String itemId) async {
    var url = Uri.parse(apiBaseUrl);
    Uint8List imageBytes = await _downloadImage(imageUrl);
    String base64Image = base64Encode(imageBytes);

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'messages': [
          {
            'role': 'system',
            'content': 'Analyze and approximate the food in the following image. Provide its name, weight, calories, protein, fat, and carbs as a JSON object. Do not return other information!'
          },
          {
            'role': 'user',
            'content': base64Image,
          }
        ],
        'model': 'gpt-4o-2024-05-13',
      })
    );

    MyRecord record;



    if (response.statusCode == 200) {
      var odata = jsonDecode(response.body);
      String content = odata['choices'][0]['message']['content'];
      content = content.replaceAll('```json', '').replaceAll('```', '').trim();
      var data = jsonDecode(content);
      record = MyRecord(
        id: int.parse(itemId),
        foodName: data['name'],
        foodImage: imageUrl,
        weight: 'Weight: ${data['weight']}g',
        calories: 'Calories: ${data['calories']}',
        protein: 'Protein: ${data['protein']}g',
        fat: 'Fat: ${data['fat']}g',
        carbs: 'Carbs: ${data['carbs']}g',
        date: DateTime.now().toString(),
      );
    
      return record;
    }else {
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
}
