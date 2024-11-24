import 'package:cat_breed_recognizer/screens/homescreen.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double? _height, _width;

  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 5)); // Display for 5 seconds
    // Navigate to homescreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Homescreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Cat Breed Recognizer",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //display splash image
          Center(
            child: Image.asset(
              'assets/flutter_logo.png',
              width: _width! * 0.65,
              height: _height! * 0.65,
            ),
          ),
          SizedBox(height: _height! * 0.05),
          cicularIndicator(),
          SizedBox(height: _height! * 0.05),
        ],
      ),
    );
  }

  Widget cicularIndicator() {
    return const CircularProgressIndicator(
      backgroundColor: Colors.black,
      color: Colors.yellow,
    );
  }
}
