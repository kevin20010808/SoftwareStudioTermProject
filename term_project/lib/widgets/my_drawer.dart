import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';
import 'package:term_project/services/providers/user_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarIndexProvider = Provider.of<BottomNavBarIndexProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final username = userProvider.username;

    void onItemTapped(int index) {
      bottomNavBarIndexProvider.setIndex(index);
      if (index == 0) {
        context.go('/profile');
      } else if (index == 1) {
        context.go('/home');
      } else if (index == 2) {
        context.go('/list');
      } else if (index == 3) {
        context.go('/');
      }
      Navigator.pop(context);
    }

    return Drawer(
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the drawer
              context.go('/profile'); // Navigate to the profile page
            },
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color.fromARGB(232, 2, 95, 64)),
              accountName: Text(
                username ?? 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                user?.email ?? 'No Email',
                style: const TextStyle(
                  color: Color.fromARGB(255, 179, 179, 179),
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
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
                        //Spacer(flex: 1),
                        Expanded(
                          flex: 6,
                          child: Divider(),
                        ),
                        Spacer(flex: 1),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
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
              IconData icon = Icons.home;
              switch (index) {
                case 0:
                  title = 'Profile';
                  icon = Icons.person;
                  break;
                case 1:
                  title = 'Home';
                  icon = Icons.home;
                  break;
                case 2:
                  title = 'List';
                  icon = Icons.list;
                  break;
              }
              return ListTile(
                leading: Icon(icon),
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
