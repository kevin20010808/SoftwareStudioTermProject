import 'package:flutter/material.dart';
import 'package:term_project/widgets/app_bar.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:term_project/widgets/recent_photo.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer:  const MyDrawer(),
      bottomNavigationBar: const MyAppBar(),
      body: Column(
          children: <Widget>[
            // User Greeting
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hi, XXNoobMei...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Progress Indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: _buildCircularProgressIndicator(0.25, 'Daily goal')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCircularProgressIndicator(0.12, 'Monthly goal')),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your recent food data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 200, // Fixed height for the scrolling area
                    child: RecentPhoto(),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildCircularProgressIndicator(double percentage, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            value: percentage,
            strokeWidth: 6,
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

