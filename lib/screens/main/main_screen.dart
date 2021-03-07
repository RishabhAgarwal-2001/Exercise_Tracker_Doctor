import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It gives us the width and height of the Screen
    Size _size = MediaQuery.of(context).size;
    return Scaffold (
      body: Center(
          child: Text("Main Screen")
      )
    );
  }
  
}