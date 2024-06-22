import 'package:flutter/material.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:term_project/widgets/recent_photo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _totalCalories = 0;
  final int _caloriesLimit = 2000;

  void _onCaloriesChanged(int totalCalories) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _totalCalories = totalCalories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double dailyGoalPercentage = _totalCalories / _caloriesLimit;
    double monthlyGoalPercentage = _totalCalories / (_caloriesLimit * 30); // Assuming 30 days for simplicity

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Green Background Box with Calories and Goals
                ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    height: 370,
                    color: Colors.green[200]?.withOpacity(1), // Green background color with opacity
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Text(
                          'Calories Left',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_caloriesLimit - _totalCalories}',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'of $_caloriesLimit kcal',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _buildCircularProgressIndicator(dailyGoalPercentage, 'Daily goal'),
                              _buildCircularProgressIndicator(monthlyGoalPercentage, 'Monthly goal'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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
                      RecentPhoto(
                        onCaloriesChanged: _onCaloriesChanged,
                      ),
                    ],
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
          height: 80, // Adjusted height
          width: 80, // Adjusted width
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 80, // Match the size of the SizedBox
                  width: 80, // Match the size of the SizedBox
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 8, // Adjusted stroke width
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(percentage * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width , size.height + 10);
    var firstEndPoint = Offset(size.width, size.height - 50);
    var secondControlPoint = Offset(size.width - 150, size.height + 10);
    var secondEndPoint = Offset(size.width, size.height-50);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
