import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  File? image; 
  final ImagePicker pickerImage = ImagePicker();

  pickImageFromGallery() async {
    var imageFile = await pickerImage.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
    }
  }

  captureImageFromCamera() async {
    var imageFile = await pickerImage.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text("hack 1"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            uploadedImage(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: pickImageFromGallery,
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
                ElevatedButton.icon(
                  onPressed: captureImageFromCamera,
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadedImage() {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        gradient: const RadialGradient(radius: 1,
          colors: [Colors.black, Colors.amber],
        ),
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: image == null
          ? const Center(
              child: Text(
                "No Image Selected",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image!,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
