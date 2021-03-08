import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/models/Patient.dart';
import 'package:exercise_tracker_doctor/constants.dart';
import 'package:exercise_tracker_doctor/screens/main/components/patient_card.dart';
import 'dart:async';
import 'package:exercise_tracker_doctor/screens/main/components/side_menu.dart';

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

  void applyFilter(int filterType) {
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
    else {
      debugPrint("Invalid Option Found");
    }
  }

  @override
  void initState() {
    super.initState();
    _filteredPatients = patients;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        // TODO: Add Drawer Here
        child: SideMenu(notifyParent: applyFilter,)
      ),
      body: Container(
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
                        press:(){}
                    )
                  )
              )
            ],
          )
        )
      )
    );
  }

}