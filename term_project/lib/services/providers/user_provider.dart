import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _username;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _user;
  String? get username => _username;

  void setUser(User? user) {
    _user = user;
    if (_user != null) {
      fetchUserData();
    } else {
      _username = null;
      notifyListeners();
    }
  }

  Future<void> fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
        if (userDoc.exists) {
          _username = userDoc['username'];
        } else {
          _username = 'No Name';
        }
        notifyListeners();
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }
}
