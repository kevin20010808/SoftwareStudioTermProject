import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/models/my_record.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/services/image_analysis_service.dart';
import 'package:term_project/services/providers/image_provider.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = Provider.of<ImagesProvider>(context).imageUrl;

    //[DUMMY START]
    /*
    final dummyService = ImageAnalysisService();
    var dummy = MyRecord();
    dummy.id = 10;
    dummy.foodName = 'Food Name';
    dummy.foodImage = 'https://shutr.bz/4c9X5xK';
    dummy.calories = '100 kcal';
    dummy.protein = '10g';
    dummy.fat = '5g';
    dummy.carbs = '20g';
    dummy.weight = '100g';
    dummy.date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (photoUrl == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Details')),
        body: SingleChildScrollView(
          child: FutureBuilder<void>(
            future: dummyService.analyzeImageAndGetRecord(
                "https://shutr.bz/4c9X5xK", '10'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  children: [
                    if (dummy.foodImage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 300.0,
                        child: Image.network(
                          dummy.foodImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    Container(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            dummy.foodName,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            'Date added: ${dummy.date}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 20, 54, 21),
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'NUTRITIONAL FACTS',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.local_fire_department, color: Colors.white),
                      title: Text('Calories', style: TextStyle(color: Colors.white)),
                      subtitle: Text(dummy.calories, style: TextStyle(color: Colors.white)),
                      tileColor: Color.fromARGB(255, 49, 98, 49),
                    ),
                    ListTile(
                      leading: Icon(Icons.fastfood, color: Colors.white),
                      title: Text('Carbohydrates', style: TextStyle(color: Colors.white)),
                      subtitle: Text(dummy.carbs, style: TextStyle(color: Colors.white)),
                      tileColor: Color.fromARGB(255, 32, 137, 29),
                    ),
                    ListTile(
                      leading: Icon(Icons.fitness_center, color: Colors.white),
                      title: Text('Protein', style: TextStyle(color: Colors.white)),
                      subtitle: Text(dummy.protein, style: TextStyle(color: Colors.white)),
                      tileColor: Color.fromARGB(255, 14, 175, 22),
                    ),
                    ListTile(
                      leading: Icon(Icons.opacity, color: Colors.white),
                      title: Text('Fat', style: TextStyle(color: Colors.white)),
                      subtitle: Text(dummy.fat, style: TextStyle(color: Colors.white)),
                      tileColor: Color.fromARGB(255, 90, 204, 58),
                    ),
                    ListTile(
                      leading: Icon(Icons.scale, color: Colors.white),
                      title: Text('Weight', style: TextStyle(color: Colors.white)),
                      subtitle: Text(dummy.weight, style: TextStyle(color: Colors.white)),
                      tileColor: Color.fromARGB(255, 86, 188, 81),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    }*/
    //[DUMMY END]

    if (photoUrl == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Analysing image...')),
      );
    }
    
    // Use the AI return.
    var record = MyRecord();
    record = record.add(photoUrl, int.parse(itemId));
    final Future<void> saveFuture = FirebaseService.instance.updateRecord(record, record.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: saveFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: [
                  if (photoUrl.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No image URL'),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 300.0,
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  Container(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          record.foodName,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          'Date added: ${record.date}',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 20, 54, 21),
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'NUTRITIONAL FACTS',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_fire_department, color: Colors.white),
                    title: Text('Calories', style: TextStyle(color: Colors.white)),
                    subtitle: Text(record.calories, style: TextStyle(color: Colors.white)),
                    tileColor: Color.fromARGB(255, 49, 98, 49),
                  ),
                  ListTile(
                    leading: Icon(Icons.fastfood, color: Colors.white),
                    title: Text('Carbohydrates', style: TextStyle(color: Colors.white)),
                    subtitle: Text(record.carbs, style: TextStyle(color: Colors.white)),
                    tileColor: Color.fromARGB(255, 32, 137, 29),
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center, color: Colors.white),
                    title: Text('Protein', style: TextStyle(color: Colors.white)),
                    subtitle: Text(record.protein, style: TextStyle(color: Colors.white)),
                    tileColor: Color.fromARGB(255, 14, 175, 22),
                  ),
                  ListTile(
                    leading: Icon(Icons.opacity, color: Colors.white),
                    title: Text('Fat', style: TextStyle(color: Colors.white)),
                    subtitle: Text(record.fat, style: TextStyle(color: Colors.white)),
                    tileColor: Color.fromARGB(255, 90, 204, 58),
                  ),
                  ListTile(
                    leading: Icon(Icons.scale, color: Colors.white),
                    title: Text('Weight', style: TextStyle(color: Colors.white)),
                    subtitle: Text(record.weight, style: TextStyle(color: Colors.white)),
                    tileColor: Color.fromARGB(255, 86, 188, 81),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


//     return Scaffold(
//       appBar: AppBar(title: const Text('Item Details')),
//       body: FutureBuilder<MyRecord?>(
//         future: imageService.analyzeImageAndGetRecord(photoUrl, itemId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || snapshot.data == null) {
//             return const Center(child: Text('Failed to analyze image'));
//           } else {
//             final record = snapshot.data!;
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   if (record.foodImage.isNotEmpty)
//                     Image.network(record.foodImage),
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
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }