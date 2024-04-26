import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: ListView.builder(
        itemCount: 10,
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
    );
  }

}