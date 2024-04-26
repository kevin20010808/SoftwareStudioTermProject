import 'package:flutter/material.dart';
import 'package:term_project/widgets/app_bar.dart';
import 'package:term_project/widgets/my_drawer.dart';


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
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Your recent food data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200, // Fixed height for the scrolling area
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4, // Number of items in your list
                      itemBuilder: (context, index) {
                        // Return a widget for your food data here, e.g., an image inside a card
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 16), // Fixed width for each item
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/food_$index.jpg'),
                          ),
                        );
                      },
                    ),
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