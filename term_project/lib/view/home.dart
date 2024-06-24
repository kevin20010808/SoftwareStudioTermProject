import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:term_project/models/my_user.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:term_project/widgets/recent_photo.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
  double tdee = 0.0;

  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;
  late AnimationController _controller6;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;
  late Animation<double> _animation6;

  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<double> _opacityAnimation3;
  late Animation<double> _opacityAnimation4;
  late Animation<double> _opacityAnimation5;
  late Animation<double> _opacityAnimation6;

  final List<bool> _isVisible = [false, false, false, false, false, false];

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
    _controller6 = AnimationController(
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
    _animation6 = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller6,
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
    _opacityAnimation6 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller6,
        curve: Curves.easeOut,
      ),
    );

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

  void _onVisibilityChanged(bool visible, int index) {
    if (visible) {
      if (!_isVisible[index]) {
        _isVisible[index] = true;
        _getController(index).reset();
        _getController(index).forward();
      }
    } else {
      _isVisible[index] = false;
      _getController(index).reset();
    }
  }

  AnimationController _getController(int index) {
    switch (index) {
      case 0:
        return _controller1;
      case 1:
        return _controller2;
      case 2:
        return _controller3;
      case 3:
        return _controller4;
      case 4:
        return _controller5;
      case 5:
      default:
        return _controller6;
    }
  }

  Animation<double> _getOpacityAnimation(int index) {
    switch (index) {
      case 0:
        return _opacityAnimation1;
      case 1:
        return _opacityAnimation2;
      case 2:
        return _opacityAnimation3;
      case 3:
        return _opacityAnimation4;
      case 4:
        return _opacityAnimation5;
      case 5:
      default:
        return _opacityAnimation6;
    }
  }

  Animation<double> _getAnimation(int index) {
    switch (index) {
      case 0:
        return _animation1;
      case 1:
        return _animation2;
      case 2:
        return _animation3;
      case 3:
        return _animation4;
      case 4:
        return _animation5;
      case 5:
      default:
        return _animation6;
    }
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
                        height: 420,
                        color: themeProvider.isDarkTheme
                            ? const Color.fromARGB(255, 44, 10, 106)?.withOpacity(0.5)
                            : Colors.green[200]?.withOpacity(1), // Color based on theme
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 40),
                            VisibilityDetector(
                              key: Key('greeting'),
                              onVisibilityChanged: (visibilityInfo) {
                                _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, 0);
                              },
                              child: AnimatedBuilder(
                                animation: _controller1,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _getOpacityAnimation(0),
                                    child: Transform.translate(
                                      offset: Offset(0, _getAnimation(0).value),
                                      child: Text(
                                        'Hi, ${myUser?.username ?? 'User'}', // Display username if available
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            VisibilityDetector(
                              key: Key('caloriesLeftLabel'),
                              onVisibilityChanged: (visibilityInfo) {
                                _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, 1);
                              },
                              child: AnimatedBuilder(
                                animation: _controller2,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _getOpacityAnimation(1),
                                    child: Transform.translate(
                                      offset: Offset(0, _getAnimation(1).value),
                                      child: const Text(
                                        'Calories Left',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            VisibilityDetector(
                              key: Key('caloriesLeftValue'),
                              onVisibilityChanged: (visibilityInfo) {
                                _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, 2);
                              },
                              child: AnimatedBuilder(
                                animation: _controller3,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _getOpacityAnimation(2),
                                    child: Transform.translate(
                                      offset: Offset(0, _getAnimation(2).value),
                                      child: Text(
                                        '${2000}', // Adjust the calculation as needed
                                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            VisibilityDetector(
                              key: Key('caloriesGoalLabel'),
                              onVisibilityChanged: (visibilityInfo) {
                                _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, 3);
                              },
                              child: AnimatedBuilder(
                                animation: _controller4,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _getOpacityAnimation(3),
                                    child: Transform.translate(
                                      offset: Offset(0, _getAnimation(3).value),
                                      child: const Text(
                                        'of 2000 kcal', // Adjust the calculation as needed
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            VisibilityDetector(
                              key: Key('progressIndicators'),
                              onVisibilityChanged: (visibilityInfo) {
                                _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, 4);
                              },
                              child: AnimatedBuilder(
                                animation: _controller5,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _getOpacityAnimation(4),
                                    child: Transform.translate(
                                      offset: Offset(0, _getAnimation(4).value),
                                      child: Padding(
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
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    VisibilityDetector(
                      key: Key('recentFoodData'),
                      onVisibilityChanged: (visibilityInfo) {
                        _onVisibilityChanged(visibilityInfo.visibleFraction > 0.1, 5);
                      },
                      child: AnimatedBuilder(
                        animation: _controller6,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _getOpacityAnimation(5),
                            child: Transform.translate(
                              offset: Offset(0, _getAnimation(5).value),
                              child: Padding(
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
                            ),
                          );
                        },
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
