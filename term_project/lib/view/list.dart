import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:term_project/services/camera_service.dart';
import 'package:term_project/services/providers/image_provider.dart';
import 'package:term_project/widgets/app_bar.dart';
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
    return Scaffold(
      bottomNavigationBar: const MyAppBar(),
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('List'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            width: 300,
            child: InkWell(
              onTap: () async {
                String? url = await _cameraService.takePicture(context);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Provider.of<ImagesProvider>(context, listen: false).setImageUrl(url);
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    context.go('/list/result'); // 确保 '/result' 路径已在 GoRouter 中正确配置
                  }
                } else {
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to take or upload picture')),
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
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, itemId) {
                return ListTile(
                  title: Text('Item $itemId'),
                  onTap: () {
                    context.go('/list/$itemId');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
