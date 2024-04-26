import 'package:flutter/material.dart';
import 'package:term_project/widgets/app_bar.dart';
// import 'package:term_project/widgets/my_drawer.dart';

class ItemScreen extends StatefulWidget {
  final String itemId;
  const ItemScreen({super.key, required this.itemId});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const MyDrawer(),
      bottomNavigationBar: const MyAppBar(),
      appBar: AppBar(title: const Text('Item Detail')),
      body: Center(
        child: Text('Item ${widget.itemId}'),
      ),
    );
  }
}