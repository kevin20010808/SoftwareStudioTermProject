import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:term_project/services/camera_service.dart';
import 'package:term_project/services/providers/image_provider.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final CameraService _cameraService = CameraService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: const Text('List'),
        ),
        body: Row(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.green,
                tabs: const [
                  Tab(text: 'Cat1'),
                  Tab(text: 'Cat2'),
                  Tab(text: 'Cat3'),
                ],
              ),
            ),
            VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: 300,
                    child: InkWell(
                      onTap: () async {
                        String? url = await _cameraService.takePicture(context);
                        if (mounted) {
                          Provider.of<ImagesProvider>(context, listen: false)
                              .setImageUrl(url);
                          if (mounted) {
                            context.go('/main/list/result');
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to take or upload picture')),
                            );
                          }
                        }
                      },
                      child: const Card(
                        color: Color.fromARGB(232, 2, 95, 64),
                        child: Center(
                          child: Text(
                            'Add item',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildCategoryList(context, 'cat1'),
                        _buildCategoryList(context, 'cat2'),
                        _buildCategoryList(context, 'cat3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, String category) {
    final items = {
      'cat1': ['Item 0 in cat1', 'Item 1 in cat1'],
      'cat2': ['Item 2 in cat2', 'Item 3 in cat2'],
      'cat3': ['Item 4 in cat3', 'Item 5 in cat3'],
    };

    return ListView.builder(
      itemCount: items[category]!.length,
      itemBuilder: (context, index) {
        final itemId = '${category}_$index';
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: ListTile(
            title: Text(items[category]![index]),
            subtitle: Text('Description for ${items[category]![index]}'),
            onTap: () {
              context.go('/main/list/$itemId');
            },
          ),
        );
      },
    );
  }
}
