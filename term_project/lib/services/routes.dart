import 'package:go_router/go_router.dart';
import 'package:term_project/view/home.dart';
import 'package:term_project/view/profile.dart';
import 'package:term_project/view/list.dart';
import 'package:term_project/view/item_detail.dart';
import 'package:term_project/view/login_page.dart';
import 'package:term_project/view/result_page.dart';


final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path:  'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'list', 
          builder: (context, state) => const ListScreen(),
          routes: <RouteBase>[
            GoRoute(path: 'result', 
              builder: (context, state) => const DisplayPhotoPage()
            ),
            GoRoute(
              path: ':itemId',
              builder: (context, state) =>  ItemDetailScreen(itemId: state.pathParameters['itemId']!)
            ),
          ],
        ),

      ]
    ),
    
  ]
);