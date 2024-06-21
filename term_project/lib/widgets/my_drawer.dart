import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarIndexProvider = Provider.of<BottomNavBarIndexProvider>(context, listen: false); 
    
    void onItemTapped(int index) {  
      bottomNavBarIndexProvider.setIndex(index);
      if (index == 0) {
        context.go('/home');
      } else if (index == 1) {
        context.go('/list');
      } else if (index == 2) {
        context.go('/profile');
      } else if (index == 3){
        context.go('/');
      }
      Navigator.pop(context);
    }

    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(232, 2, 95, 64)),
            accountName: Text('John Doe'),
            accountEmail: Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              if (index == 3) {
                return Column(
                  children: [
                    Row(
                      children: const [
                        //Spacer(flex: 1), // Add space before the divider
                        Expanded(
                          flex: 6, // Adjust the flex value to control the width of the divider
                          child: Divider(),
                        ),
                        Spacer(flex: 1), // Add space after the divider
                      ],
                    ),
                    ListTile(
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red), // Set the text color to red
                      ),
                      onTap: () => onItemTapped(index),
                    ),
                  ],
                );
              }

              String title = '';
              switch (index) {
                case 0:
                  title = 'Home';
                  break;
                case 1:
                  title = 'List';
                  break;
                case 2:
                  title = 'Profile';
                  break;
              }
              return ListTile(
                title: Text(title),
                onTap: () => onItemTapped(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
