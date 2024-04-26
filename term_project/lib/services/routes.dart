import 'package:go_router/go_router.dart';
import 'package:term_project/view/home.dart';
import 'package:term_project/view/profile.dart';
import 'package:term_project/view/list.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path:  '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/list', 
      builder: (context, state) => const ListScreen(),
    ),
  ]
);