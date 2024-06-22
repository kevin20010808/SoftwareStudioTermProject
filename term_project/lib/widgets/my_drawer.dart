import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarIndexProvider =
        Provider.of<BottomNavBarIndexProvider>(context);
    User? user = FirebaseAuth.instance.currentUser;

    void onItemTapped(int index) {
      bottomNavBarIndexProvider.setIndex(index);

      if (index == 0) {
        context.go('/main');
      } else if (index == 1) {
        context.go('/main');
      } else if (index == 2) {
        context.go('/main');
      } else if (index == 3) {
        context.go('/');
        bottomNavBarIndexProvider.setIndex(0);
      }
      Navigator.pop(context);
      
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(232, 2, 95, 64)),
            accountName: Text(user?.displayName ?? ''),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
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
                    const Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Divider(),
                        ),
                        Spacer(flex: 1),
                      ],
                    ),
                    ListTile(
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
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
