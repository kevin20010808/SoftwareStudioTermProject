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
      if (index == 1) {
        context.go('/list');
      } else if (index == 0) {
        context.go('/');
      } else if (index == 2) {
        context.go('/profile');
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
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) { 
              String title = '';
              switch (index) {
                case 0:
                  title = 'Home';
                  break;
                case 2:
                  title = 'Profile';
                  break;
                case 1:
                  title = 'List';
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