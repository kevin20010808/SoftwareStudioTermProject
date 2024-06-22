import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/widgets/my_drawer.dart';
import 'package:term_project/updater/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).loadProfileData();
  }

  void _editProfile() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    String? newUsername = profileProvider.username;
    int? newAge = profileProvider.age;
    double? newHeight = profileProvider.height;
    double? newWeight = profileProvider.weight;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  controller: TextEditingController(text: profileProvider.username),
                  onChanged: (value) => newUsername = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: profileProvider.age.toString()),
                  onChanged: (value) => newAge = int.tryParse(value),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: profileProvider.height.toString()),
                  onChanged: (value) => newHeight = double.tryParse(value),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: profileProvider.weight.toString()),
                  onChanged: (value) => newWeight = double.tryParse(value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newUsername != null && newAge != null && newHeight != null && newWeight != null) {
                  profileProvider.updateProfile(
                    username: newUsername!,
                    age: newAge!,
                    height: newHeight!,
                    weight: newWeight!,
                  );
                  profileProvider.saveProfileData();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
            padding: const EdgeInsets.only(top: kToolbarHeight + 16.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreen],
                      ),
                    ),
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileItem('Username:', profileProvider.username),
                _buildProfileItem('Age:', profileProvider.age.toString()),
                _buildProfileItem('Height:', '${profileProvider.height} cm'),
                _buildProfileItem('Weight:', '${profileProvider.weight} kg'),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _editProfile,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
