import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';
import '../services/camera_service.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});
  


  @override
  Widget build(BuildContext context) {
    final bottomNavBarIndexProvider = Provider.of<BottomNavBarIndexProvider>(context, listen: false); 
    
    
    void onItemTapped(int index) {  
      bottomNavBarIndexProvider.setIndex(index);
      
      if (index == 1) {
        // takePicture();
        context.go('/list');
      } else if (index == 0) {
        // Handle other navigation items
        context.go('/');
      } else if (index == 2) {
        // Handle other navigation items
        context.go('/profile');
      }

    }

    return 
      BottomNavigationBar(
        currentIndex: bottomNavBarIndexProvider.selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'list'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: onItemTapped,
      );
  //   );
  
  }
}

