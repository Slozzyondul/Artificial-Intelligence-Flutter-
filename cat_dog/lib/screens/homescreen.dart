import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? deviceHeight, deviceWidth;

  late File _image;
  late List<dynamic>? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future<void> detectImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        _output = output;
      });
    } catch (e) {
      debugPrint("Error running model: $e");
    }
  }

  // detectImage(File image) async {
  //   var output = await Tflite.runModelOnImage(
  //     path: image.path,
  //     numResults: 2,
  //     threshold: 0.6,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //   );
  //   setState(() {
  //     _output = output!;
  //   });
  // }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
      );
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  // loadModel() async {
  //   await Tflite.loadModel(
  //     model: 'assets/model_unquant.tflite',
  //     labels: 'assets/labels.txt',
  //   );
  // }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  captureImageUsingCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      print("No image selected.");
      return;
    }

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  uploadImageFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      print("No image selected.");
      return;
    }

    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsetsDirectional.all(2),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              const Text(
                'What you looking for',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Test it here to know if it is a cat or a dog?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(), // Expands to take up remaining space
              ),
              useCamera(),
              SizedBox(
                height: deviceHeight! * 0.25,
              ),
              uploadImage(),
              SizedBox(
                height: deviceHeight! * 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }

//widget to use camera
  Widget useCamera() {
    return GestureDetector(
      onTap: () {
        captureImageUsingCamera();
      },
      child: Container(
        width: deviceWidth! - 250,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "Use your cam",
          style: TextStyle(color: Colors.yellow),
        ),
      ),
    );
  }

//widget to upload image from local storage
  Widget uploadImage() {
    return GestureDetector(
      onTap: () {
        uploadImageFromGallery();
      },
      child: Container(
        width: deviceWidth! - 150,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "upload form storage",
          style: TextStyle(color: Colors.yellow),
        ),
      ),
    );
  }

  Widget resultOutput() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: deviceHeight! * 0.5,
          child: Image.file(_image),
        ),
        SizedBox(height: deviceHeight! * 0.025),
        _output != null
            ? Text(
                '${_output![0]['label']}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            : Expanded(
                child: Container(),
              ),
        SizedBox(
          height: deviceHeight! * 0.025,
        ),
      ],
    );
  }
}