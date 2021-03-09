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
    "image": "assets/Images/person1.jpg",
    "operation": "Knee Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": true,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/Images/person2.jpg",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/Images/person3.jpg",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": true,
    "totalTreatmentLength": 30,
    "treatmentDay": 13
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/Images/person4.jpg",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 40,
    "treatmentDay": 25
  },
  {
    "name": "Rajeev Jain",
    "image": "assets/Images/person5.jpg",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": true,
    "totalTreatmentLength": 45,
    "treatmentDay": 23
  },
  {
    "name": "Kavita",
    "image": "assets/Images/person6.jpg",
    "operation": "Wrist Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 20,
    "treatmentDay": 13
  },
  {
    "name": "Mike Jain",
    "image": "assets/Images/person7.png",
    "operation": "Boulder Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 69,
    "treatmentDay": 1
  },
  {
    "name": "Jack",
    "image": "assets/Images/person8.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": true,
    "totalTreatmentLength": 32,
    "treatmentDay": 14
  },
  {
    "name": "Washington",
    "image": "assets/Images/person9.png",
    "operation": "Brain Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": true,
    "totalTreatmentLength": 38,
    "treatmentDay": 9
  },
  {
    "name": "Ritik Maheshwari",
    "image": "assets/Images/img.png",
    "operation": "Shoulder Operation",
    "isDoingExerciseOnTime": true,
    "criticalStatus": false,
    "totalTreatmentLength": 32,
    "treatmentDay": 19
  },
  {
    "name": "Harish Yadav",
    "image": "assets/Images/img.png",
    "operation": "Kidney Operation",
    "isDoingExerciseOnTime": false,
    "criticalStatus": false,
    "totalTreatmentLength": 29,
    "treatmentDay": 28
  }
];