import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});
  


  @override
  Widget build(BuildContext context) {
    final bottomNavBarIndexProvider = Provider.of<BottomNavBarIndexProvider>(context, listen: false); 
    
    
    void onItemTapped(int index) {  
      bottomNavBarIndexProvider.setIndex(index);
      
      if (index == 0) {
        context.go('/home');
      } else if (index == 1) {
        // Handle other navigation items
        context.go('/list');
      } else if (index == 2) {
        // Handle other navigation items
        context.go('/profile');
      }

    }

    return 
      BottomNavigationBar(
        //if bottomNavBarIndexProvider.selectedIndex<=3 then currentIndex is bottomNavBarIndexProvider.selectedIndex else currentIndex is 0
        currentIndex: bottomNavBarIndexProvider.selectedIndex<3?bottomNavBarIndexProvider.selectedIndex:0,
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

