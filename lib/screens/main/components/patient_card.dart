import 'package:exercise_tracker_doctor/constants.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/models/Patient.dart';

class PatientCard extends StatelessWidget {

  const PatientCard({
    Key key,
    this.patient,
    this.press
  });

  final Patient patient;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: InkWell(
        onTap: press,
        child: Text("${patient.name}")
      )
    );
  }

}