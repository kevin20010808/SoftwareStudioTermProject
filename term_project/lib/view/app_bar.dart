import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:term_project/view/home.dart';

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


class MyAppBar extends StatefulWidget {
  final Widget body;

  const MyAppBar({super.key, required this.body});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Widget get body => widget.body;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
    if (index == 1) {
      // Future.microtask(() => _takePicture());
    } else if (index == 0) {
      // Handle other navigation items
      Future.microtask(() =>  const MyAppBar(body: Home()));

    } else if (index == 2) {
      // Handle other navigation items
        Future.microtask(() => const MyAppBar(body: ProfileScreen()));
    }
    
  }

  // Future<void> _showAddFoodModal(BuildContext context) async {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 500,
  //         padding: const EdgeInsets.all(20),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             ElevatedButton.icon(
  //               icon: const Icon(Icons.camera_alt),
  //               label: const Text('Take a Picture'),
  //               onPressed: () {
  //                 _takePicture();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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

    // Save the image to the gallery
    await saveImageToGallery(savedImage);
    // ignore: avoid_print
    print('Image saved at: ${savedImage.path}');
  }


  // if (!mounted) return;
  // Navigator.of(context).pop(); // Close the modal if it's open
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Title'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index == 1) {
            Future.microtask(() => _takePicture());
          }
          setState(() => _selectedIndex = index);
        },
        children: <Widget>[
          const Home(),
          Container(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Foody'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

