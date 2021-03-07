import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/models/Patient.dart';
import 'package:exercise_tracker_doctor/constants.dart';
import 'package:exercise_tracker_doctor/screens/main/components/patient_card.dart';

class ListOfPatients extends StatefulWidget {
  const ListOfPatients({
    Key key,
  }) : super(key: key);

  @override
  _ListOfPatientsState createState() => _ListOfPatientsState();
}

class _ListOfPatientsState extends State<ListOfPatients> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        // TODO: Add Drawer Here
        child: Text("Drawer")
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
                        onChanged: (value) => print("Value = $value"), // TODO: When Value changes Apply Filter
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
                    itemCount: patients==null ? 0: patients.length,
                    itemBuilder: (context, index) => PatientCard(
                        patient: patients[index],
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