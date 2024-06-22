// services/image_analysis_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:term_project/models/my_record.dart';

class ImageAnalysisService {
  final String apiBaseUrl = 'https://api.openai.com/v1/images/generate-description';
  final String apiKey = 'YOUR_API_KEY';

  Future<MyRecord?> analyzeImageAndGetRecord(String imageUrl, String itemId) async {
    var url = Uri.parse(apiBaseUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'prompt': 'Analyze and approximate the food in the following image. Provide its name, weight, calories, protein, fat, and carbs as a JSON object. Do not return other information!',
        'image': imageUrl
      })
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return MyRecord(
        id: int.parse(itemId),
        foodName: data['name'],
        foodImage: imageUrl,
        weight: 'Weight: ${data['weight']}g',
        calories: 'Calories: ${data['calories']}',
        protein: 'Protein: ${data['protein']}g',
        fat: 'Fat: ${data['fat']}g',
        carbs: 'Carbs: ${data['carbs']}g',
      );
    }
    return null;
  }
}
