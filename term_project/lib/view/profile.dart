import 'package:flutter/material.dart';
import 'home.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                // If you have an image, you can use the Image.network or Image.asset widget
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Username:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('XxNoobMaster69xX'),
            const SizedBox(height: 16),
            const Text(
              'Age:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('69'),
            const SizedBox(height: 16),
            const Text(
              'Height:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('169 cm'),
            const SizedBox(height: 16),
            const Text(
              'Weight:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('169 kg'),
          ],
        ),
      ),
    );
  }
}
