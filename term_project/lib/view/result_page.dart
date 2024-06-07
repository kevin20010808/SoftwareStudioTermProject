import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/services/providers/image_provider.dart';

class DisplayPhotoPage extends StatelessWidget {
  const DisplayPhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final photoUrl = Provider.of<ImagesProvider>(context).imageUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Uploaded Photo')),
      body: Center(
        child: photoUrl == null
            ? const Text('No image URL')
            : Image.network(photoUrl),
      ),
    );
  }
}
