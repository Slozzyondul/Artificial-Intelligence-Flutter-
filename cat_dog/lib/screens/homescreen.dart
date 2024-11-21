import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? deviceHeight, deviceWidth;
  String? _error;
  late File _image;
  late List<String> _labels;
  late Interpreter _interpreter;
  List<dynamic>? _output;
  final picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadModelAndLabels().then((_) {
      setState(() {
        _isLoading = false; // Loading complete
      });
    });
  }

  void interpretResults(List<double> output) {
    const labels = ['cat', 'dog'];
    final maxIndex = output
        .indexWhere((prob) => prob == output.reduce((a, b) => a > b ? a : b));
    print('Prediction: ${labels[maxIndex]}, Confidence: ${output[maxIndex]}');
  }

  Future<void> loadModelAndLabels() async {
    final directory =
        await getApplicationSupportDirectory(); //Or get other relevant directory for your needs (like getApplicationDocumentsDirectory())
    final projectPath = directory.path.split('/cat_dog')[0] + '/cat_dog';
    try {
      // Load the model
      _interpreter = await Interpreter.fromFile(
          File('$projectPath/assets/model_unquant.tflite'));
      debugPrint("Model loaded successfully.");

      // Load labels
      String labelData =
          await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      debugPrint("Labels loaded successfully: $labelData");

      _labels = labelData.split('\n');
//checkin if flutter can load model
      final byteData = await DefaultAssetBundle.of(context)
          .load('assets/model_unquant.tflite');
      print(
          "Model file loaded successfully, size: ${byteData.lengthInBytes} bytes");
    } catch (e) {
      print("Error loading model file: $e");
      setState(() {
        _isLoading = false;
        _error = "Error loading model or labels: $e";
      });
    }
  }

  Future<List<double>> runInference(List<List<List<double>>> input) async {
    // Load the model

    // Prepare the input tensor
    final inputTensor = [input]; // Add batch dimension

    // Prepare the output tensor
    final outputTensor = List.filled(1 * 2, 0.0).reshape([1, 2]);

    // Run the model

    _interpreter.run(inputTensor, outputTensor);

    // Close the interpreter
    _interpreter.close();

    // Return the output probabilities
    return outputTensor[0];
  }

  Future<void> detectImage(File image) async {
    try {
      // Preprocess the image
      final preprocessedImage = await preprocessImage(image);

      // Run inference
      final result = await runInference(preprocessedImage);

      // Interpret results
      setState(() {
        _output = [
          {
            'label': _labels[result.indexWhere(
                (val) => val == result.reduce((a, b) => a > b ? a : b))],
            'confidence': result.reduce((a, b) => a > b ? a : b)
          }
        ];
      });
    } catch (e) {
      debugPrint("Error running model: $e");
    }
  }

  // Future<void> detectImage(File image) async {
  //   try {
  //     // Preprocess the image
  //     Uint8List input = await preprocessImage(image);

  //     // Create input and output tensors
  //     var output =
  //         List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

  //     // Run the model
  //     _interpreter.run(input, output);

  //     // Get the results
  //     int maxIndex = output[0].indexWhere(
  //         (value) => value == output[0].reduce((a, b) => a > b ? a : b));
  //     setState(() {
  //       _output = [
  //         {'label': _labels[maxIndex], 'confidence': output[0][maxIndex]}
  //       ];
  //     });
  //   } catch (e) {
  //     debugPrint("Error running model: $e");
  //   }
  // }

  Future<List<List<List<double>>>> preprocessImage(File imageFile) async {
    // Load and decode the image
    final img.Image? originalImage =
        img.decodeImage(await imageFile.readAsBytes());

    // Resize to 224x224
    final img.Image resizedImage =
        img.copyResize(originalImage!, width: 224, height: 224);

    // Normalize pixel values to [0, 1]
    final List<List<List<double>>> normalizedImage = List.generate(
      resizedImage.height,
      (y) => List.generate(
        resizedImage.width,
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            pixel.r / 255.0, // Red channel
            pixel.g / 255.0, // Green channel
            pixel.b / 255.0, // Blue channel
          ];
        },
      ),
    );

    return normalizedImage;
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
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    } else {
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
  }

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
          "upload from storage",
          style: TextStyle(color: Colors.yellow),
        ),
      ),
    );
  }
}
