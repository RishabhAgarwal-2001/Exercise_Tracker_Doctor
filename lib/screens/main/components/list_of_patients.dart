import 'dart:math';

import 'package:exercise_tracker_doctor/services/authServices/UserTypeService.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/models/Patient.dart';
import 'package:exercise_tracker_doctor/constants.dart';
import 'package:exercise_tracker_doctor/screens/main/components/patient_card.dart';
import 'dart:async';
import 'package:exercise_tracker_doctor/screens/main/components/side_menu.dart';
import 'package:exercise_tracker_doctor/screens/patient/patient.dart';
import 'package:exercise_tracker_doctor/screens/patient/addPatient.dart';
import 'dart:convert';

// TODO (1): Add Shimmer While Loading

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ListOfPatients extends StatefulWidget {
  const ListOfPatients({
    Key key,
  }) : super(key: key);

  @override
  _ListOfPatientsState createState() => _ListOfPatientsState();
}

class _ListOfPatientsState extends State<ListOfPatients> {
  final _debouncer = Debouncer(milliseconds: 500);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Patient> _filteredPatients = List();
  int filterOption = 1;
  bool isLoading;
  UserTypeService userService;
  String department, designation, hospital;

  void applyFilter(int filterType) {
    filterOption = filterType;
    if(filterType==1) {
      _debouncer.run(
              () {
            setState((){
              _filteredPatients = patients;
              debugPrint("Showing All Patients");
            });
          }
      );
    }
    else if(filterType==2) {
      _debouncer.run(
              () {
            setState((){
              _filteredPatients = patients.where(
                      (p) => (
                      p.isDoingExerciseOnTime
                  )
              ).toList();
              debugPrint("Showing Patients which are on schedule");
            });
          }
      );
    }
    else if(filterType==3) {
      _debouncer.run(
              () {
            setState((){
              _filteredPatients = patients.where(
                      (p) => (
                      !(p.isDoingExerciseOnTime)
                  )
              ).toList();
              debugPrint("Patients Not Doing Exercise on Time");
            });
          }
      );
    }
    else if(filterType==4) {
      _debouncer.run(
              () {
            setState((){
              _filteredPatients = patients.where(
                      (p) => (
                      p.criticalStatus
                  )
              ).toList();
              debugPrint("Patients with Critical Status");
            });
          }
      );
    }
    else if(filterType==5) {
      _debouncer.run(
              () {
            setState((){
              _filteredPatients = patients.where(
                      (p) => (
                      p.treatmentDay==p.totalTreatmentLength
                  )
              ).toList();
              debugPrint("Patients Who Completed the Treatment");
            });
          }
      );
    }
    else if(filterType==6) {
      _debouncer.run(
              () {
            setState((){
              _filteredPatients = patients.where(
                      (p) => (
                      p.isMarked
                  )
              ).toList();
              debugPrint("Patients Who are marked as Important");
            });
          }
      );
    }
    else {
      debugPrint("Invalid Option Found");
    }
  }

  List<Patient> getPatientList(List<dynamic>response) {
  List<Patient> patients = List.generate(response.length, (index) => Patient(
    name: response[index][1] + " " + response[index][2],
    image: response[index][3],
    operation: response[index][4],
    isDoingExerciseOnTime: (response[index][7] == 1 && response[index][6] == 1) ? true : false,
    criticalStatus: response[index][9] == 1 ? true: false,
    totalTreatmentLength: 60,
    treatmentDay: response[index][5],
    mobile: response[index][0],
    isMarked: response[index][8] == 1 ? true: false,
  ));
  return patients;
}


  Future<void> _getPatients() async {
    setState(() {
      isLoading = true;
    });
    String response = await userService.getPatients();
    String profileResponse = await userService.getDoctorProfile();
    List<dynamic> list = json.decode(response);
    Map<String, dynamic> map = json.decode(profileResponse);
    hospital = map["profile"]["hospital"];
    designation = map["profile"]["designation"];
    department = map["profile"]["department"];
    print(list);
    print(map);
    patients = getPatientList(list);
    _filteredPatients = patients;
    print(_filteredPatients);
    setState(() {
      isLoading = false;
    });
  }

  void sortPatients() {
    patients.sort((a, b){
      String x = a.isMarked ? '1' : '0';
      String y = b.isMarked ? '1' : '0';
      return x.compareTo(y);
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _filteredPatients = patients;
    userService = UserTypeService();
    _getPatients().catchError((e){
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: userService.userType==0 ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddPatient(),
            ),
          );
        },
        label: const Text('New Patient'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ) : null,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        // TODO: Add Drawer Here
        child: SideMenu(notifyParent: applyFilter, filterActive: filterOption, refreshPage: _getPatients,
        department: department, designation: designation, hospital: hospital)
      ),
      body:Stack(
        children: <Widget>[
          Container(
              color: kBgDarkColor,
              child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding/2),
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    _scaffoldKey.currentState.openDrawer();
                                  }
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                  child: TextField(
                                      onChanged: (value) {
                                        _debouncer.run(
                                                () {
                                              setState((){
                                                _filteredPatients = patients.where(
                                                        (p) => (
                                                        p.name.toLowerCase().contains(value.toLowerCase())
                                                    )
                                                ).toList();
                                                print(_filteredPatients);
                                              });
                                            }
                                        );
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Search",
                                          fillColor: kBgLightColor,
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              borderSide: BorderSide.none
                                          )
                                      )
                                  )
                              )
                            ],
                          )
                      ),
                      SizedBox(height: kDefaultPadding), // SizedBox
                      Expanded(
                          child: ListView.builder(
                              itemCount: _filteredPatients==null ? 0: _filteredPatients.length,
                              itemBuilder: (context, index) => PatientCard(
                                  patient: _filteredPatients[index],
                                  handleTap:(){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DashboardOnePage(patient: patients[index]),
                                      ),
                                    );
                                  },
                                handleLongPress: () async {
                                  int marked = 1;
                                  if(_filteredPatients[index].isMarked) marked = 0;
                                  Patient oldPatient = _filteredPatients[index];
                                  Patient newPatient = new Patient(
                                    treatmentDay: oldPatient.treatmentDay,
                                    totalTreatmentLength: oldPatient.totalTreatmentLength,
                                    criticalStatus: oldPatient.criticalStatus,
                                    isDoingExerciseOnTime: oldPatient.isDoingExerciseOnTime,
                                    operation: oldPatient.operation,
                                    image: oldPatient.image,
                                    mobile: oldPatient.mobile,
                                    name: oldPatient.name,
                                    isMarked: !oldPatient.isMarked,
                                  );
                                  int idx = patients.indexOf(oldPatient);
                                  patients[idx] = newPatient;
                                  sortPatients();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  try{
                                    String code = await userService.pinPatient(_filteredPatients[index].mobile.toString(), marked);
                                    if(code!="200") {
                                      patients[idx] = oldPatient;
                                    }
                                  } catch(err) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                handleCriticalityChange: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Patient oldPatient = _filteredPatients[index];
                                    int idx = patients.indexOf(oldPatient);
                                    Patient newPatient = new Patient(
                                      treatmentDay: oldPatient.treatmentDay,
                                      totalTreatmentLength: oldPatient.totalTreatmentLength,
                                      criticalStatus: !oldPatient.criticalStatus,
                                      isDoingExerciseOnTime: oldPatient.isDoingExerciseOnTime,
                                      operation: oldPatient.operation,
                                      image: oldPatient.image,
                                      mobile: oldPatient.mobile,
                                      name: oldPatient.name,
                                      isMarked: oldPatient.isMarked,
                                    );
                                    patients[idx] = newPatient;
                                    setState(() {
                                      isLoading=false;
                                    });
                                    String response = await userService.setCriticalStatus(oldPatient.mobile.toString(), newPatient.criticalStatus);
                                    if(response!="200") {
                                      print('Failed to Change at Backend');
                                      patients[idx] = oldPatient;
                                      setState(() {
                                        isLoading=false;
                                      });
                                    }
                                }
                              )
                          )
                      )
                    ],
                  )
              )
          ),
          isLoading == true? Container(
              color: Colors.black.withOpacity(0.5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator(),)):Container(),
        ],
      )
    );
  }

}