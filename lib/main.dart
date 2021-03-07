import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Tracker (Doctor)')
        ),
      )
    );
  }
}