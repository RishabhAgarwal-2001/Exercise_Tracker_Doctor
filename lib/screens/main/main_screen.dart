import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/screens/main/components/list_of_patients.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It gives us the width and height of the Screen
    Size _size = MediaQuery.of(context).size;
    return Scaffold (
        // TODO: Add List of Patients Here
        body: Center(
          child: ListOfPatients()
      )
    );
  }
  
}