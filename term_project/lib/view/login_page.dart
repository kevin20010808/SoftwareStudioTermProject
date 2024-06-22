import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:term_project/models/my_user.dart';
import 'package:term_project/services/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _message = '';

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      MyUser newUser = MyUser(
        id: userCredential.user!.uid,
        username: _usernameController.text,
        email: _emailController.text,
      );
      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());

      Provider.of<UserProvider>(context, listen: false).setUser(userCredential.user);
      await Provider.of<UserProvider>(context, listen: false).fetchUserData();

      setState(() {
        _message = 'Successfully registered: ${newUser.email}';
        context.go('/home');
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to register: $e';
      });
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Provider.of<UserProvider>(context, listen: false).setUser(userCredential.user);
      await Provider.of<UserProvider>(context, listen: false).fetchUserData();

      setState(() {
        _message = 'Successfully logged in: ${userCredential.user?.email}';
        context.go('/home');
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to log in: $e';
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      MyUser newUser = MyUser(
        id: userCredential.user!.uid,
        username: googleUser.displayName ?? '',
        email: googleUser.email,
      );
      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());

      Provider.of<UserProvider>(context, listen: false).setUser(userCredential.user);
      await Provider.of<UserProvider>(context, listen: false).fetchUserData();

      setState(() {
        _message = 'Successfully logged in with Google: ${newUser.email}';
        context.go('/home');
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to log in with Google: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithGoogle,
              child: const Text('Login with Google'),
            ),
            const SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
