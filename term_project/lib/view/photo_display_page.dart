import 'package:flutter/material.dart';

class PhotoDisplayPage extends StatelessWidget {
  final String photoUrl;

  const PhotoDisplayPage({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Photo'),
      ),
      body: Center(
        child: photoUrl.isNotEmpty
            ? Image.network(photoUrl)
            : const Text('No photo available'),
      ),
    );
  }
}
