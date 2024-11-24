import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
} 

class _HomescreenState extends State<Homescreen> {
  double? _height, _width;

  late Future<File> imageFile;
  File? _image;
  String result = '';
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadDataModelsFiles();
  }

  loadDataModelsFiles() async {}

  imageClassification() async {}

  // Function to select a photo from the gallery
  Future<void> selectPhoto() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageClassification();
      });
    }
  }

  // Function to capture a photo using the camera
  Future<void> capturePhoto() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageClassification();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/ai.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(width: _width! * 0.05),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: TextButton(
                          onPressed: selectPhoto,
                          onLongPress: capturePhoto,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: _height! * 0.05,
                              left: _width! * 0.05,
                              right: _width! * 0.05,
                            ),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    height: _height! * 0.5,
                                    width: _width! * 0.5,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    width: _width! * 0.5,
                                    height: _height! * 0.5,
                                    child: const Icon(
                                      size: 80,
                                      Icons.camera_alt,
                                      color: Colors.yellow,
                                    ),
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _height! * 0.05),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
