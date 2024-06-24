import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';
import 'package:term_project/models/my_record.dart';
import 'package:term_project/services/firestore_service.dart';
import 'package:term_project/services/providers/image_provider.dart';
import 'package:term_project/services/camera_service.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RecentPhoto extends StatefulWidget {
  final Function(int) onCaloriesChanged;

  const RecentPhoto({super.key, required this.onCaloriesChanged});

  @override
  _RecentPhotoState createState() => _RecentPhotoState();
}

class _RecentPhotoState extends State<RecentPhoto> with TickerProviderStateMixin {
  List<MyRecord> _foodItems = [];
  final CameraService _cameraService = CameraService();
  bool _hasMoreThanFourItems = false;

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<double>> _opacityAnimations;
  final List<bool> _isVisible = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadRecentFoodItems();
  }

  void _initializeAnimations() {
    _controllers = List.generate(10, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 15.0, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    _isVisible.addAll(List.generate(10, (index) => false));
  }

  Future<void> _loadRecentFoodItems() async {
    List<MyRecord> allRecords = await FirebaseService.instance.loadAllRecords();
    String today = DateFormat('yyyy/MM/dd').format(DateTime.now());

    List<MyRecord> dailyRecords = allRecords
        .where((record) => record.dateTime == today)
        .toList();

    dailyRecords.sort((a, b) => b.id.compareTo(a.id));
    print('Total daily records: ${dailyRecords.length}');

    _hasMoreThanFourItems = dailyRecords.length > 4;
    //print( dailyRecords.length );

    if (dailyRecords.length > 4) {
      _foodItems = dailyRecords.take(4).toList();
    } else {
      _foodItems = dailyRecords;
    }

    _updateCalories();
    setState(() {
      print('Loaded ${_foodItems.length} items. More than 4 items: $_hasMoreThanFourItems');
    });
  }

  void _updateCalories() {
    //final totalCalories = _foodItems.fold<int>(0, (sum, item) => sum + int.parse(item.calories.replaceAll('Calories: ', '')));
    //widget.onCaloriesChanged(totalCalories);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVisibilityChanged(bool visible, int index) {
    if (visible) {
      if (!_isVisible[index]) {
        _isVisible[index] = true;
        _controllers[index].reset();
        _controllers[index].forward();
      }
    } else {
      _isVisible[index] = false;
      _controllers[index].reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _foodItems.isEmpty
            ? Center(
                child: Column(
                  children: [
                    const Text('Go take a photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        MyRecord? newRecord = await _cameraService.takePicture(context);
                        if (newRecord != null && mounted) {
                          setState(() {
                            _loadRecentFoodItems();
                          });
                          Provider.of<ImagesProvider>(context, listen: false).setImageUrl(newRecord.foodImage);
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to take or upload picture')),
                          );
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  return VisibilityDetector(
                    key: Key('photo-$index'),
                    onVisibilityChanged: (visibilityInfo) {
                      _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, index);
                    },
                    child: AnimatedBuilder(
                      animation: _controllers[index],
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _opacityAnimations[index],
                          child: Transform.translate(
                            offset: Offset(0, _animations[index].value),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          foodItem.foodName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${foodItem.calories} CAL',
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
                                      onTap: () => context.go('/main/list/${foodItem.id}'),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetImage('assets/food_2.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
        if (_hasMoreThanFourItems)
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
