import 'package:cat_breed_recognizer/screens/homescreen.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double? height, width;

  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 5)); // Display for 5 seconds
    // Navigate to homescreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Homescreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Cat Breed Recognizer",
            style: TextStyle(
              color: Colors.black,
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
              width: width! * 0.65,
              height: height! * 0.65,
            ),
          ),
          SizedBox(height: height! * 0.05),
          cicularIndicator(),
          SizedBox(height: height! * 0.05),
        ],
      ),
    );
  }

  Widget cicularIndicator() {
    return const CircularProgressIndicator();
  }
}
