import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                  final dummyService = ImageAnalysisService();

    return WillPopScope(
      onWillPop: () async {
        context.go('/main');
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/main');
            },
          ),
        ),
        body: Builder(
          builder: (context) {

    var dummy = MyRecord();
    dummy.id = 10;
    dummy.foodName = 'Food Name';
    dummy.foodImage = 'https://shutr.bz/4c9X5xK';
    dummy.calories = '100 kcal';
    dummy.protein = '10g';
    dummy.fat = '5g';
    dummy.carbs = '20g';
    dummy.weight = '100g';
    dummy.dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
            if (photoUrl == null) {
                  if (photoUrl == null) {
      return Scaffold(
        //appBar: AppBar(title: const Text('Item Details')),
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
                            'Date added: ${dummy.dateTime}',
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
    }
            }
            
            // Use the AI return.
            var record = MyRecord();
            record = record.add(photoUrl, int.parse(itemId));
            final Future<void> saveFuture = FirebaseService.instance.updateRecord(record, record.id);

            return SingleChildScrollView(
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
                                'Date added: ${record.dateTime}',
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
            );
          },
        ),
      ),
    );
  }
}
