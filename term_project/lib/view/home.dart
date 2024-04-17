import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'profile.dart';

import 'dart:typed_data';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> saveImageToGallery(File file) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final File imageFile = File(image.path);

    if (await _requestStoragePermission()) {
      final String fileName = path.basename(imageFile.path);
      final Uint8List bytes = await imageFile.readAsBytes();
      final result = await ImageGallerySaver.saveImage(bytes, name: fileName);
      // ignore: avoid_print
      print('Image saved to Gallery: $result');
    }
  }
}

Future<bool> _requestStoragePermission() async {

  if (await Permission.manageExternalStorage.status.isDenied) {
    await Permission.manageExternalStorage.request();
  }
  var status = await Permission.manageExternalStorage.status;

  return status.isGranted;
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 1) {
      _showAddFoodModal(context);
    } else if (index == 0) {
      // Handle other navigation items
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (Route<dynamic> route) => false,
        );
    } else if (index == 2) {
      // Handle other navigation items
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
          (Route<dynamic> route) => false,
        );
    }
    
  }

  Future<void> _showAddFoodModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take a Picture'),
                onPressed: () {
                  _takePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }

Future<void> _takePicture() async {
  // Ensure the storage permission is granted
  if (!await _requestStoragePermission()) {
    // Handle the case where the user does not grant permission
    // ignore: avoid_print
    print('Storage permission not granted');
    return;
  }

  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);

  

  if (image != null) {
    final File imageFile = File(image.path);

    // Get the external storage directory
    final Directory? externalDir = (await getExternalStorageDirectory());

    // Create a specific folder inside the external storage directory
    final String customDirPath = path.join(externalDir!.path, 'lib/services/cache_photo');
    final Directory customDir = Directory(customDirPath);

    // If the directory does not exist, create it
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    // Copy the file from the temporary location to the new directory
    final String fileName = path.basename(imageFile.path);
    final String savedImagePath = path.join(customDir.path, fileName);
    final File savedImage = await imageFile.copy(savedImagePath);

    // ignore: avoid_print
    print('Image saved at: ${savedImage.path}');
  }
  if (!mounted) return;
  Navigator.of(context).pop(); // Close the modal if it's open
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Title'),
      ),
      body: const Home(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Food'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

}











class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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