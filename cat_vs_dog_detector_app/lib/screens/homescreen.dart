import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? deviceHeight, deviceWidth;
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
      onTap: () {},
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
      onTap: () {},
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
}
