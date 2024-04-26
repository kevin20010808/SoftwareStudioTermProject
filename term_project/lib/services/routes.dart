import 'package:go_router/go_router.dart';
import 'package:term_project/view/home.dart';
import 'package:term_project/view/profile.dart';
import 'package:term_project/view/list.dart';
import 'package:term_project/view/item_detail.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
      routes: <RouteBase>[
        GoRoute(
          path:  'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'list', 
          builder: (context, state) => const ListScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: ':itemId',
              builder: (context, state) =>  ItemScreen(itemId: state.pathParameters['itemId']!)
            ),
          ],
        ),
      ]
    ),
    
  ]
);