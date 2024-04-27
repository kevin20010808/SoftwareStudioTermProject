import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:term_project/services/camera_service.dart';
import 'package:term_project/widgets/app_bar.dart';
import 'package:term_project/widgets/my_drawer.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>{


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
              onTap: () => takePicture(),
              child:  const Card(
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
                    // Add your logic here
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