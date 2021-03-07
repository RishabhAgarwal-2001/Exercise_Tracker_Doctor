import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/screens/main/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This is the Root of Our Application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise Tracker',
      theme: ThemeData(),
      home: MainScreen(),
    );
  }
}