import 'package:exercise_tracker_doctor/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:exercise_tracker_doctor/widgets/IconImages.dart';
import 'package:exercise_tracker_doctor/services/authServices/UserTypeService.dart';


class AddPatient extends StatefulWidget {

  @override
  _AddPatient createState() => _AddPatient();
}

class _AddPatient extends State<AddPatient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameFirst = new TextEditingController();
  final TextEditingController _userNameSecond = new TextEditingController();
  final TextEditingController _department = new TextEditingController();
  final TextEditingController _designation = new TextEditingController();
  final TextEditingController _hospital = new TextEditingController();
  final TextEditingController _patientMobileNumber = new TextEditingController();
  final TextEditingController _staff1MobileNumber = new TextEditingController();
  final TextEditingController _staff2MobileNumber = new TextEditingController();
  final TextEditingController _treatmentStartDate = new TextEditingController();
  final TextEditingController _treatmentEndDate = new TextEditingController();
  bool isLoading;
  UserTypeService userService;

  final outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: const BorderRadius.all(
      const Radius.circular(50),
    ),
  );

  final textFieldPadding = const EdgeInsets.only(bottom: 5, left: 20);

  final filledColor = Color.fromRGBO(0,0,0, 0.11);

  final hintTextStyle = new TextStyle(
      color: Colors.grey.withOpacity(0.5), fontSize: 14);
  final hintTextStyleSolid = new TextStyle(
      color: Colors.grey.withOpacity(1), fontSize: 14);


  void successPushPage(int statusCode){

    print("Pushing with status code " + statusCode.toString());

    if(userService.userType == 0 && statusCode == 200){ // Doctor
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen()));
    }
    else if(userService.userType == 1 && statusCode == 200){ // Staff
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen())); //todo
    }
    else{
      print("Some error");
    }
  }

  Future<void> _registerDoctor() async {
    setState(() {
      isLoading = true;
    });
    print("Line Number 60");
    int statusCode = await userService.registerDoctor(_userNameSecond.text, _userNameSecond.text, _department.text, _designation.text,_hospital.text);
    if(statusCode==200) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen()));
    }
  }

  Future<void> _addPatient() async {
    setState(() {
      isLoading = true;
    });
    print("Make an API Call Here to Add Patient");
    int statusCode = await userService.addPatient(_patientMobileNumber.text, _treatmentStartDate.text, _treatmentEndDate.text, _staff1MobileNumber.text, _staff2MobileNumber.text);
    setState(() {
      isLoading = false;
    });
  }


  String _mobileValidator(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);

    if (value.trim().length != 10)
      return 'Mobile Number must be of 10 digit';
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    else
      return null;
  }

  String _staffMobileValidator(String value) {
    if(value.trim().length == 0) return null;
    else return _mobileValidator(value);
  }


  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2019),
      lastDate: new DateTime(2025)
    );
    if(picked!=null){
      return "${picked.year.toString()}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
    }
  }

  @override
  void initState() {
    isLoading = false;
    userService = UserTypeService();
    DateTime today = new DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return Scaffold(
                body : SingleChildScrollView(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 38),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container()
                                      ],
                                    ),
                                  ),
                                  Center(
                                      child: TreatmentIconLogoSmall()
                                  ),
                                ],
                              ),
                              flex: 100,
                            ),
                            Expanded(
                              child: Container(
                                // color: Colors.pink,
                                  padding: EdgeInsets.only(
                                      left: width * (30 / 375),
                                      right: width * (30 / 375)),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Center(
                                              child: Text(
                                                "New Patient",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )),

                                          TextFormField(
                                            onSaved: (String val) {},
                                            validator: _mobileValidator,
                                            keyboardType: TextInputType.phone,
                                            controller: _patientMobileNumber,
                                            decoration: new InputDecoration(
                                              suffixIcon: Icon(Icons.call),

                                              fillColor: filledColor,
                                              filled: true,
                                              contentPadding: textFieldPadding,
                                              enabledBorder: outlineBorder,
                                              focusedBorder: outlineBorder,
                                              hintStyle: hintTextStyleSolid,
                                              hintText: "Patient Mobile Number",
                                            ),
                                            maxLines: 1,
                                          ),

                                          TextFormField(
                                            onSaved: (String val) {},
                                            onTap: () async {
                                              _treatmentStartDate.text = await _selectDate();
                                            },
                                            readOnly: true,
                                            // validator: _mobileValidator,
                                            keyboardType: null,
                                            controller: _treatmentStartDate,
                                            decoration: new InputDecoration(
                                              suffixIcon: Icon(Icons.calendar_today),

                                              fillColor: filledColor,
                                              filled: true,
                                              contentPadding: textFieldPadding,
                                              enabledBorder: outlineBorder,
                                              focusedBorder: outlineBorder,
                                              hintStyle: hintTextStyleSolid,
                                              hintText: "Treatment Start Date",
                                            ),
                                            maxLines: 1,
                                          ),

                                          TextFormField(
                                            onSaved: (String val) {},
                                            onTap: () async{
                                              _treatmentEndDate.text = await _selectDate();
                                            },
                                            // validator: _mobileValidator,
                                            readOnly: true,
                                            controller: _treatmentEndDate,
                                            decoration: new InputDecoration(
                                              suffixIcon: Icon(Icons.calendar_today),

                                              fillColor: filledColor,
                                              filled: true,
                                              contentPadding: textFieldPadding,
                                              enabledBorder: outlineBorder,
                                              focusedBorder: outlineBorder,
                                              hintStyle: hintTextStyleSolid,
                                              hintText: "Treatment End Date",
                                            ),
                                            maxLines: 1,
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, bottom: 9,top: 20),
                                                child: Text(
                                                  "Staff Information",
                                                  style: hintTextStyleSolid,
                                                ),
                                              ),
                                              TextFormField(
                                                validator: _staffMobileValidator,
                                                onSaved: (String val) {},
                                                keyboardType: TextInputType.phone,
                                                controller: _staff1MobileNumber,//tocahgne
                                                decoration: new InputDecoration(
                                                  suffixIcon: Icon(Icons.supervised_user_circle)
                                                  ,
                                                  fillColor: filledColor,
                                                  filled: true,
                                                  contentPadding: textFieldPadding,
                                                  enabledBorder: outlineBorder,
                                                  focusedBorder: outlineBorder,
                                                  hintStyle: hintTextStyleSolid,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ) ,
                                          TextFormField(
                                            validator: _staffMobileValidator,
                                            onSaved: (String val) {},
                                            keyboardType: TextInputType.phone,
                                            controller: _staff2MobileNumber,//tocahnge
                                            decoration: new InputDecoration(
                                              suffixIcon: Icon(Icons.supervised_user_circle)
                                              ,
                                              fillColor: filledColor,
                                              filled: true,
                                              contentPadding: textFieldPadding,
                                              enabledBorder: outlineBorder,
                                              focusedBorder: outlineBorder,
                                              hintStyle: hintTextStyleSolid,
                                              hintText: "Staff 2 Mobile Number(optional)",
                                            ),
                                            maxLines: 1,
                                          ),
                                          InkWell(
                                              onTap: () async{
                                                if(_formKey.currentState.validate()){
                                                  await _addPatient().catchError((e){
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  });

                                                }
                                                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen()));
                                              },
                                              child: RaisedPinkButton("Submit")),
                                        ],
                                      ))),
                              flex: 200,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "",

                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "",

                                        ),
                                        InkWell(
                                          onTap: (){

                                          },
                                          child: Text(
                                            "",
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              flex: 60,
                            ),
                          ],
                        ),
                      ),
                      isLoading == true? Container(
                          color: Colors.black.withOpacity(0.5),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: CircularProgressIndicator(),)):Container(),
                    ],
                  ),
                )
            );
          }),
    );

  }
}


class RaisedPinkButton extends StatelessWidget {
  RaisedPinkButton(this.str, {this.fontSize = 15, this.onlyBorder = false});
  final String str;
  final double fontSize;
  final bool onlyBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: onlyBorder == false ? LinearGradient(
              begin: Alignment(-1.0, 0.0),
              end: Alignment(1.0, 0.0),
              transform: GradientRotation((math.pi) / (360 / 191)),
              colors: [
                Color.fromRGBO(228, 34, 69, 1),
                Color.fromRGBO(228, 34, 69, 0),
              ],
              stops: [
                0.5,
                1
              ]
          ) : null,
          border: onlyBorder == false ? null : Border.all(
              color: Color.fromRGBO(228, 34, 69, 1), width: 3)
      ),
      height: 50,
      child: Center(
        child: Text(
            str, style: TextStyle(color: Colors.white, fontSize: fontSize)),
      ),
    );
  }
}
