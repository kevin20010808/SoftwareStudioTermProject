import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/navbar_index_provider.dart';
import 'package:term_project/services/providers/user_provider.dart';
import 'package:term_project/services/providers/image_provider.dart';
import 'services/routes.dart'; // Import your routes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavBarIndexProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // UserProvider for user data
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router, // Use the router configuration
    );
  }
}
