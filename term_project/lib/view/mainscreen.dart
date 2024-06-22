import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';
import 'package:term_project/view/home.dart';
import 'package:term_project/view/profile.dart';
import 'package:term_project/view/list.dart';
import 'package:term_project/widgets/app_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _MainScreenContent(),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomNavBarIndexProvider =
        Provider.of<BottomNavBarIndexProvider>(context);

    return IndexedStack(
      index: bottomNavBarIndexProvider.selectedIndex,
      children: const [
        Home(),
        ListScreen(),
        ProfileScreen(),
      ],
    );
  }
}
