import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  double? _height, _width;
  File? _image;
  String result = '';
  late ImagePicker imagePicker;
  late Interpreter _interpreter;
  late List<String> labels;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadModelAndLabels();
  }

  Future<void> loadModelAndLabels() async {
    try {
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset('model_unquant.tflite');

      // Load the labels
      final labelData = await File('assets/labels.txt').readAsLines();
      labels = labelData;

      print('Model and labels loaded successfully.');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> imageClassification() async {
    if (_image == null) return;

    // Load and preprocess the image
    final inputImage = FileImage(_image!).file.readAsBytesSync();
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();
    final inputTensor = TensorImage.fromFile(File(_image!.path));
    imageProcessor.process(inputTensor);

    // Allocate output tensor
    final outputTensor = TensorBuffer.createFixedSize(
        <int>[1, labels.length], TfLiteType.float32);

    // Run inference
    _interpreter.run(inputTensor.buffer, outputTensor.buffer);

    // Post-process results
    final probabilityProcessor = TensorLabel.fromList(
      labels,
      outputTensor,
    );
    final probabilities = probabilityProcessor.getMapWithFloatValue();

    // Get the most probable label
    final topResult =
        probabilities.entries.reduce((a, b) => a.value > b.value ? a : b);

    setState(() {
      result = topResult.key; // Display the top label
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Breed Recognizer'),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
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
                                Icons.camera_alt,
                                color: Colors.yellow,
                              ),
                            ),
                    ),
                  ),
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
    );
  }
}
