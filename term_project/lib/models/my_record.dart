import 'package:intl/intl.dart';

class MyRecord {
  int id;
  String foodName;
  String foodImage;
  String calories;
  String protein; 
  String fat;
  String carbs; 
  String weight;
  String dateTime; // New field

  MyRecord({
    this.id = 0,
    this.foodName = '',
    this.foodImage = '',
    this.calories = '',
    this.protein = '',
    this.fat = '',
    this.carbs = '',
    this.weight = '',
    this.dateTime = '', // Initialize new field
  });

  factory MyRecord.fromJson(Map<String, dynamic> firestore) {
    return MyRecord(
      id: firestore['id'] ?? 0,
      foodName: firestore['foodName'] ?? '',
      foodImage: firestore['foodImage'] ?? '',
      calories: firestore['calories'] ?? '',
      protein: firestore['protein'] ?? '',
      fat: firestore['fat'] ?? '',
      carbs: firestore['carbs'] ?? '',
      weight: firestore['weight'] ?? '',
      dateTime: firestore['dateTime'] ?? '', // Extract date
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodName': foodName,
      'foodImage': foodImage,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'weight': weight,
      'dateTime': dateTime, // Include date
    };
  }

  MyRecord add(String photoUrl, int id) {
    String currentDateTime = DateFormat('yyyy/MM/dd').format(DateTime.now());
    return MyRecord(
      id: id,
      foodName: 'Food Name',
      foodImage: photoUrl, 
      calories: 'Calories: 100',
      protein: 'Protein: 10g',
      fat: 'Fat: 5g',
      carbs: 'Carbs: 20g',
      weight: 'Weight: 100g',
      dateTime: currentDateTime, // Use formatted date
    );
  }
}
