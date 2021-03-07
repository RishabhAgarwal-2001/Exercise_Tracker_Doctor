import 'package:flutter/material.dart';

// Class to Model Each Patient
class Patient {
  final String name, image, operation;
  final bool isDoingExerciseOnTime, criticalStatus;
  final int totalTreatmentLength, treatmentDay;

  Patient({
    this.name,
    this.image,
    this.operation,
    this.isDoingExerciseOnTime,
    this.criticalStatus,
    this.totalTreatmentLength,
    this.treatmentDay
  });
}

// TODO: Update to take Data from API call
// Generating Dummy Data
List<Patient> patients = List.generate(
    demo_data.length,
    (index) => Patient(
      name: demo_data[index]["name"],
      image: demo_data[index]["image"],
      operation: demo_data[index]["operation"],
      isDoingExerciseOnTime: demo_data[index]["isDoingExerciseOnTime"],
      criticalStatus: demo_data[index]["criticalStatus"],
      totalTreatmentLength: demo_data[index]["totalTreatmentLength"],
      treatmentDay: demo_data[index]["treatmentDay"]
    )
);

List demo_data = [
  {
    "name": "Patient 1",
    "image": "assets/images/img.png",
    "operation": "XYZ",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  }
];