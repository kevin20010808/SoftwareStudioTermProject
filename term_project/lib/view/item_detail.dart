import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/models/my_record.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/services/providers/image_provider.dart'; 

class ItemDetailScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = Provider.of<ImagesProvider>(context).imageUrl;

    if (photoUrl == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Analysing image...')),
      );
    }

    // get the record from the Firestore database
    final saveFuture = FirebaseService.instance.getRecordById(int.parse(itemId));

//     return Scaffold(
//       appBar: AppBar(title: const Text('Item Details')),
//       body: SingleChildScrollView(
//         child: FutureBuilder<void>(
//           future: saveFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               return Column(
//                 children: [
//                   if (photoUrl.isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Text('No image URL'),
//                     )
//                   else
//                     Image.network(photoUrl),
//                   ListTile(
//                     title: const Text('Calories'),
//                     subtitle: Text(record.calories),
//                   ),
//                   ListTile(
//                     title: const Text('Protein'),
//                     subtitle: Text(record.protein),
//                   ),
//                   ListTile(
//                     title: const Text('Fat'),
//                     subtitle: Text(record.fat),
//                   ),
//                   ListTile(
//                     title: const Text('Carbohydrates'),
//                     subtitle: Text(record.carbs),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: FutureBuilder<MyRecord?>(
        future: saveFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if ( snapshot.data == null) {
            return const Center(child: Text('Failed to analyze image'));
          } else {
            final record = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (record.foodImage.isNotEmpty)
                    Image.network(record.foodImage),
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
            );
          }
        },
      ),
    );
  }
}