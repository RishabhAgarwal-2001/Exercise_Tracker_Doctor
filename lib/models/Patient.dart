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
    "name": "Harshad Mehta",
    "image": "assets/images/img.png",
    "operation": "Knee Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/images/img.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/images/img.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/images/img.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 40,
    "treatmentDay": 25
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/images/img.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 45,
    "treatmentDay": 23
  },
  {
    "name": "Kavita",
    "image": "assets/images/img.png",
    "operation": "Wrist Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 20,
    "treatmentDay": 13
  },
  {
    "name": "Mike Jain",
    "image": "assets/images/img.png",
    "operation": "Boulder Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 69,
    "treatmentDay": 1
  },
  {
    "name": "Jack",
    "image": "assets/images/img.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 32,
    "treatmentDay": 14
  },
  {
    "name": "Washington",
    "image": "assets/images/img.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 38,
    "treatmentDay": 9
  },
  {
    "name": "Ritik Maheshwari",
    "image": "assets/images/img.png",
    "operation": "Shoulder Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 32,
    "treatmentDay": 19
  },
  {
    "name": "Harish Yadav",
    "image": "assets/images/img.png",
    "operation": "Kidney Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 29,
    "treatmentDay": 28
  }
];