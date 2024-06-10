import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/models/my_record.dart';
import 'package:term_project/services/providers/image_provider.dart';  // 确保引入正确

class ItemDetailScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = Provider.of<ImagesProvider>(context).imageUrl;

    if (photoUrl == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No image URL')),
      );
    }

    final record = MyRecord(
      id: int.parse(itemId),
      foodImage: photoUrl, 
      calories: 'Calories: 100',
      protein: 'Protein: 10g',
      fat: 'Fat: 5g',
      carbs: 'Carbs: 20g',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (photoUrl.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No image URL'),
              )
            else
              Image.network(photoUrl),
            ListTile(
              title: const Text('Calories'),
              subtitle: Text(record.calories),
            ),
            ListTile(
              title: const Text('Protein'),
              subtitle: Text(record.protein),
            ),
            ListTile(
              title: const Text('Fat'),
              subtitle: Text(record.fat),
            ),
            ListTile(
              title: const Text('Carbohydrates'),
              subtitle: Text(record.carbs),
            ),
          ],
        ),
      ),
    );
  }
}
