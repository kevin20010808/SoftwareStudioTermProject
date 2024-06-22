import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';

class RecentPhoto extends StatefulWidget {
  final Function(int) onCaloriesChanged;

  const RecentPhoto({super.key, required this.onCaloriesChanged});

  @override
  _RecentPhotoState createState() => _RecentPhotoState();
}

class _RecentPhotoState extends State<RecentPhoto> {
  List<Map<String, dynamic>> _foodItems = [
    {'title': 'Oatmeal Smoothie', 'calories': 312, 'image': 'assets/food_0.jpg'},
    {'title': 'Acai Bowl', 'calories': 458, 'image': 'assets/food_1.jpg'},
    {'title': 'Food Item With A Very Long Name', 'calories': 350, 'image': 'assets/food_2.jpg'},
    {'title': 'Food Item 4', 'calories': 400, 'image': 'assets/food_3.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _updateCalories();
  }

  void _updateCalories() {
    final totalCalories = _foodItems.fold<int>(0, (sum, item) => sum + (item['calories'] as int));
    widget.onCaloriesChanged(totalCalories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _foodItems.length > 4 ? 4 : _foodItems.length,
          itemBuilder: (context, index) {
            final foodItem = _foodItems[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodItem['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${foodItem['calories']} CAL',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () => context.go('/main/list/$index'),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(foodItem['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (_foodItems.length > 3)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Update the BottomNavBarIndexProvider before navigating
                  Provider.of<BottomNavBarIndexProvider>(context, listen: false).setIndex(1);
                  context.go('/main');
                },
                child: const Text('See All'),
              ),
            ),
          ),
      ],
    );
  }
}
