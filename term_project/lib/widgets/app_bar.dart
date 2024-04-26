import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/camera_service.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      takePicture();
    } else if (index == 0) {
      // Handle other navigation items
      context.go('/');
    } else if (index == 2) {
      // Handle other navigation items
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Foody'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      );
  //   );
  }
}

