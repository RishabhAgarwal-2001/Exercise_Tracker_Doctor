import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/screens/main/main_screen.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:exercise_tracker_doctor/screens/login/OTP/otpEnter.dart';
import 'package:exercise_tracker_doctor/screens/login/splashScreen/splashScreen.dart';
//import 'package:exercise_tracker_doctor/screens/trainingCenters/pricingRevenue/pricingAndRevenue.dart';
import 'package:exercise_tracker_doctor/screens/WelcomeBoarding/WelcomeBoarding.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:exercise_tracker_doctor/services/authServices/FirebaseUser.dart';
import 'package:exercise_tracker_doctor/services/authServices/UserTypeService.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:exercise_tracker_doctor/screens/registerUsers/registerDoctor.dart';
main() {
  runApp(
      RestartWidget(
        child: MaterialApp(
          supportedLocales: const <Locale>[
            Locale('en', ''),
          ],
          debugShowCheckedModeBanner: false,

          title: 'Exercise Tracker',
          theme: ThemeData(),
          home: TreatmentPartner(),
        ),
      )
  );
}



class TreatmentPartner extends StatefulWidget {
  @override
  _TreatmentPartnerState createState() => _TreatmentPartnerState();
}

class _TreatmentPartnerState extends State<TreatmentPartner> {
  final userService = new UserTypeService();
  final firebaseCheckService= new FirebaseSignInService();


  void _checkAppType(){



    print("inside " + userService.userType.toString() +"   "+ firebaseCheckService.user.toString());

    if((userService.userType == -1) || (firebaseCheckService.user == null) || ((userService.userRegistered == -1)) || ((userService.jwtToken == ""))){
      //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> RegisterPatientRelative()));
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> WelcomeBoarding()));
    }


    else if((userService.userType ==0) && (firebaseCheckService.user != null)){  // patient
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen()));
    }
    else if((userService.userType ==1) && (firebaseCheckService.user != null)){   // relative
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen())); //todo
    }
    else{
      print("Push Failed");
    }


  }

  @override
  void initState() {
    userService.checkUserType();
    userService.checkUserRegistered();
    userService.checkJWTToken();
    firebaseCheckService.checkLogin();

    Timer(Duration(seconds: 3), _checkAppType);  //TODO
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}



class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}


class MyApp extends StatelessWidget {
  // This is the Root of Our Application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise Tracker',
      theme: ThemeData(),
      home: MainScreen(),
    );
  }
}