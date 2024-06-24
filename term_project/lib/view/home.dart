import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:term_project/models/my_user.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:term_project/widgets/recent_photo.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/theme_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  MyUser? myUser;
  double bmr = 0.0;
  double calories = 0.0;
  double protein = 0.0;
  double fat = 0.0;
  double carbs = 0.0;
  double bmi = 0.0;

  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;

  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<double> _opacityAnimation3;
  late Animation<double> _opacityAnimation4;
  late Animation<double> _opacityAnimation5;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _controller4 = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _controller5 = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeOut,
      ),
    );
    _animation2 = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeOut,
      ),
    );
    _animation3 = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller3,
        curve: Curves.easeOut,
      ),
    );
    _animation4 = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller4,
        curve: Curves.easeOut,
      ),
    );
    _animation5 = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller5,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeOut,
      ),
    );
    _opacityAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeOut,
      ),
    );
    _opacityAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller3,
        curve: Curves.easeOut,
      ),
    );
    _opacityAnimation4 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller4,
        curve: Curves.easeOut,
      ),
    );
    _opacityAnimation5 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller5,
        curve: Curves.easeOut,
      ),
    );

    if (user != null) {
      _fetchUserData();
    }

    // Start the animations
    _controller1.forward();
    _controller2.forward();
    _controller3.forward();
    _controller4.forward();
    _controller5.forward();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
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
          bmi = _calculateBMI(myUser!.height ?? 0.0, myUser!.weight ?? 0.0);
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

  double _calculateBMI(double height, double weight) {
    return weight / ((height / 100) * (height / 100));
  }

  Widget _buildLinearProgressIndicator(double value, String label, double maxValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / maxValue,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text('${(value / maxValue * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              context.go('/main/ai');
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      themeProvider.isDarkTheme 
                      ? 'assets/dark2.png' 
                      : 'assets/background.jpg'
                    ), 
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
                        height: 620,
                        color: themeProvider.isDarkTheme
                            ? const Color.fromARGB(255, 44, 10, 106)?.withOpacity(0.5)
                            : Colors.green[100]?.withOpacity(1), // Color based on theme
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 40),
                            AnimatedBuilder(
                              animation: _controller1,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _opacityAnimation1,
                                  child: Transform.translate(
                                    offset: Offset(0, _animation1.value),
                                    child: Text(
                                      'Hi, ${myUser?.username ?? 'User'}', // Display username if available
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            AnimatedBuilder(
                              animation: _controller2,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _opacityAnimation2,
                                  child: Transform.translate(
                                    offset: Offset(0, _animation2.value),
                                    child: const Text(
                                      'Calories Left',
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            AnimatedBuilder(
                              animation: _controller3,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _opacityAnimation3,
                                  child: Transform.translate(
                                    offset: Offset(0, _animation3.value),
                                    child: Text(
                                      '${calories.toStringAsFixed(0)}', // Adjust the calculation as needed
                                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            AnimatedBuilder(
                              animation: _controller4,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _opacityAnimation4,
                                  child: Transform.translate(
                                    offset: Offset(0, _animation4.value),
                                    child: Text(
                                      'of ${bmr.toStringAsFixed(0)} kcal', // Adjust the calculation as needed
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            AnimatedBuilder(
                              animation: _controller5,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _opacityAnimation5,
                                  child: Transform.translate(
                                    offset: Offset(0, _animation5.value),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                      child: Column(
                                        children: <Widget>[
                                          _buildLinearProgressIndicator(protein, 'Protein', 100),
                                          const SizedBox(height: 16),
                                          _buildLinearProgressIndicator(fat, 'Fat', 70),
                                          const SizedBox(height: 16),
                                          _buildLinearProgressIndicator(carbs, 'Carbs', 300),
                                          const SizedBox(height: 16),
                                          _buildLinearProgressIndicator(bmi, 'BMI', 40),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                            onCaloriesChanged: (int totalCalories, double totalProtein, double totalFat, double totalCarbs) {
                              setState(() {
                                calories = totalCalories.toDouble();
                                protein = totalProtein;
                                fat = totalFat;
                                carbs = totalCarbs;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
