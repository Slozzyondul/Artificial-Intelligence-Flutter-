import 'package:cat_vs_dog_detector_app/screens/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cats vs Dogs Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Opt-in for Material 3 design
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellowAccent, // Choose your app's primary seed color
          brightness: Brightness.light, // Can change to dark if needed
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellowAccent, // App bar color
          foregroundColor: Colors.black, // App bar text/icon color
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.yellowAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellowAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

