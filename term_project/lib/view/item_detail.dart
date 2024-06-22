import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';

class ItemScreen extends StatefulWidget {
  final String itemId;
  const ItemScreen({super.key, required this.itemId});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Update the BottomNavBarIndexProvider before navigating back
        //Provider.of<BottomNavBarIndexProvider>(context, listen: false).setIndex(1);
        // Navigate back to the list screen
        context.go('/main');
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Item Detail')),
        body: Center(
          child: Text('Item ${widget.itemId}'),
        ),
      ),
    );
  }
}
