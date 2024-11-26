import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  late File image;
  String resultText = "getting output....";
  ImagePicker pickerImage = ImagePicker();

  pickImageFromGallery() async {
    var imageFile = await pickerImage.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
        loading = false;
      });
    }
  }

  captureImageUsingCamera() async {
    var imageFile = await pickerImage.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/jarvis.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Center(
                  child: loading
                      //if the condition is true, renders the UI for pick image, capture image or live image
                      ? Container(
                          padding: const EdgeInsets.only(top: 140),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                width: 250,
                                child: Image.asset("assets/camera.jpg"),
                              ),
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // live camera button
                                  SizedBox.fromSize(
                                    size: const Size(80, 80),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.yellow,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {},
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_front,
                                                size: 40,
                                              ),
                                              Text(
                                                "live camera",
                                                style: TextStyle(fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 4.0),

                                  // gallery image pick button
                                  SizedBox.fromSize(
                                    size: const Size(80, 80),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.yellow,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            pickImageFromGallery();
                                          },
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo, size: 40),
                                              Text(
                                                "gallery store",
                                                style: TextStyle(fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 4,
                                  ),

                                  // capture image using camera
                                  SizedBox.fromSize(
                                    size: const Size(80, 80),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.yellow,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            captureImageUsingCamera();
                                          },
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_alt,
                                                size: 40,
                                              ),
                                              Text(
                                                "camera",
                                                style: TextStyle(fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        )
                      //renders the UI for outputting results by applying the algorithm
                      : Container(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 200,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            resultText = "fetching output....";
                                            loading = true;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          200,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          image,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                child: Text(
                                  resultText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
