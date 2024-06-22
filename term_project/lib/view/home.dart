import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:term_project/models/my_user.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:term_project/widgets/recent_photo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  MyUser? myUser;
  double bmr = 0.0;
  double tdee = 0.0;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          myUser = MyUser.fromMap(snapshot.data()!);
          bmr = _calculateBMR(
              myUser!.age ?? 0, myUser!.height ?? 0.0, myUser!.weight ?? 0.0);
          tdee = _calculateTDEE(bmr);
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  double _calculateBMR(int age, double height, double weight) {
    // Harris-Benedict equation (generic formula, not gender-specific)
    return 66 + (6.23 * weight) + (12.7 * height) - (6.8 * age);
  }

  double _calculateTDEE(double bmr) {
    // Assuming sedentary lifestyle (activity factor = 1.2)
    return bmr * 1.2;
  }

  Widget _buildCircularProgressIndicator(double value, String label, double maxValue) {
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
                    value: value / maxValue,
                    strokeWidth: 8, // Adjusted stroke width
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(value / maxValue * 100).toStringAsFixed(1)}%',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                    height: 420,
                    color: Colors.green[200]?.withOpacity(1), // Green background color with opacity
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Text(
                          'Hi, ${myUser?.username ?? 'User'}', // Display username if available
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Calories Left',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${2000}', // Adjust the calculation as needed
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'of 2000 kcal', // Adjust the calculation as needed
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _buildCircularProgressIndicator(tdee, 'TDEE', 2500),
                              const SizedBox(width: 16),
                              _buildCircularProgressIndicator(bmr, 'BMR', 2500),
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
                        onCaloriesChanged: (int totalCalories) {
                          // Handle the calories change if needed
                        },
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
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width, size.height + 10);
    var firstEndPoint = Offset(size.width, size.height - 50);
    var secondControlPoint = Offset(size.width - 150, size.height + 10);
    var secondEndPoint = Offset(size.width, size.height - 50);

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
