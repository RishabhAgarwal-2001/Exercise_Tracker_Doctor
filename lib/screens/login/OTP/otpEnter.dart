import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:exercise_tracker_doctor/widgets/Buttons.dart';
//import 'package:exercise_tracker_doctor/screens/personalTrainerApp/homePagePersonalTrainer.dart';
import 'package:exercise_tracker_doctor/screens/main/main_screen.dart';
import 'package:exercise_tracker_doctor/services/authServices/FirebaseUser.dart';
import 'package:exercise_tracker_doctor/services/authServices/UserTypeService.dart';
import 'package:exercise_tracker_doctor/screens/registerUsers/registerDoctor.dart';

class OtpVerification extends StatefulWidget {

  final String mobileNumber;
  final int userType;

  OtpVerification({Key key,@required this.mobileNumber,@required this.userType}) : super(key: key);


  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {


  FirebaseSignInService otpService;
  String currentPin;
  TextEditingController _pinController;
  Timer _timer;
  int _start = 59;
  int _maxTime = 60;
  void startTimer() {
    _start = 59;
    _maxTime = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void successPushPage(int statusCode){

    print("Pushing with status code " + statusCode.toString());

    if(statusCode == 250){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> RegisterPatientRelative()));
    }
    else if(widget.userType == 0 && statusCode == 200){ // patient
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen()));
    }
    else if(widget.userType == 1 && statusCode == 200){ // relative
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> MainScreen())); //todo
    }
    else{
      print("Some error");
    }

  }

  Future<void> _signInWithPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _smsVerificationCode,
      smsCode: _pinController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    print(user.uid);
    assert(user.uid == currentUser.uid);
    print("trying");
    int statusCode = await userService.setRole(user,widget.mobileNumber.trim());
    successPushPage(statusCode);

  }

  Future<void> verifyPhoneNumber(BuildContext context,String mobileNumber) async {

    String phoneNumber = "+91" + mobileNumber;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 50),
        verificationCompleted: (authCredential) => _verificationComplete(authCredential, context),
        verificationFailed: (authException) => _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code])).catchError((e){
      setState(() {
        isLoading = false;
      });
    });
  }

  Future <void> _resendTokens()async{

    String phoneNumber = "+91" + widget.mobileNumber.trim();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 50),
        verificationCompleted: (authCredential) => _verificationComplete(authCredential, context),
        verificationFailed: (authException) => _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code]),
        forceResendingToken: _forceTokens[0]
    ).catchError((e){
      setState(() {
        isLoading = false;
      });
    });

  }

  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    // print("insidesddsddfsfsfsfsfs" + isLoading.toString());
    setState(() {
      isLoading = true;
    });
    int statusCode = 400;

    FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) async {

      setState(() {
        isLoading = true;
      });

      IdTokenResult id = await authResult.user.getIdToken();
      print(id);
      print(authResult.user.uid);
      final snackBar = SnackBar(content: Text("Success!!! UUID is: " + authResult.user.uid));

      print("trying");
      statusCode = await userService.setRole(authResult.user,widget.mobileNumber.trim());

      //Scaffold.of(context).showSnackBar(snackBar);
      //key.currentState.showSnackBar(snackBar);
      //Navigator.of(context).pop();
    }).catchError((e){
      setState(() {
        isLoading = false;
      });
    }).then((_){
      successPushPage(statusCode);
    });

    setState(() {
      isLoading = false;
    });

  }

  _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    print(verificationId);
    setState(() {
      _codeSent = true;
      startTimer();
    });
    _smsVerificationCode = verificationId;
    _forceTokens =code;
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    isLoading = false;
    final snackBar = SnackBar(content: Text("Login Failed Please Try Again"));
    //Scaffold.of(context).showSnackBar(snackBar);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }



  List<int> _forceTokens;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _smsVerificationCode;
  bool _codeSent;
  UserTypeService userService;




  @override
  void initState() {
    isLoading = false;
    userService = UserTypeService();
    otpService = new FirebaseSignInService();
    _pinController = new TextEditingController();
    currentPin = "";
    _codeSent = false;

    userService.setUserType(widget.userType);
    verifyPhoneNumber(context,widget.mobileNumber.trim());

    super.initState();
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Builder(builder: (context)=>SingleChildScrollView(
          child: Stack(
            children: <Widget>[

              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(108, 71, 145, 1),
                                borderRadius:  BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50)
                                )
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Verify your phone number",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Waiting to automatically detect an SMS sent to",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "+91 ${widget.mobileNumber}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: InkWell(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(Icons.edit,color: Colors.white,size: 13,)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                _codeSent==true && _start<100 ?Text(
                                  "0:$_start",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                  ),
                                ):Text(
                                  "Sending OTP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 10),
                                  child: LinearPercentIndicator(
                                    lineHeight: 9,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    percent: (_maxTime-_start)/_maxTime,
                                    progressColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: 30,left: 10),
                            child: IconButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back),
                              color: Colors.white,
                            ),
                          )
                        ],

                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Expanded(
                            flex: 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Enter the OTP below in case we fail to detect \nthe SMS automatically",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 12
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: PinCodeTextField(
                                    length: 6,
                                    obsecureText: false,
                                    animationType: AnimationType.fade,
                                    shape: PinCodeFieldShape.box,
                                    animationDuration: Duration(milliseconds: 300),
                                    borderRadius: BorderRadius.circular(10),
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    onChanged: (value) {
                                      setState(() {
                                        currentPin = value;
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    controller: _pinController,
                                    activeColor: Colors.black.withOpacity(0.3),
                                    selectedColor: Colors.blue.withOpacity(0.3),
                                    disabledColor: Colors.black.withOpacity(0.3),
                                    inactiveColor: Colors.black.withOpacity(0.3),
                                  ),
                                ),

                                SizedBox(
                                  height: 25,
                                ),
                                _start < 1 ? InkWell(
                                  onTap: () async{
                                    _start = 1000;
                                    await _resendTokens().catchError((e){
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  },
                                  child: Text(
                                    "Resend Code",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 12
                                    ),
                                  ),
                                ): InkWell(
                                  onTap: (){},
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 12
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Expanded(
                            flex: 35,
                            child: Container(
                              child: Center(
                                child: SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                      child: purpleButton("SUBMIT",function: ()async{
                                        final snackBar = SnackBar(content: Text("Please Enter a valid 6 Digit OTP"));
                                        if(_pinController.text.length <6){
                                          _scaffoldKey.currentState.showSnackBar(snackBar);
                                        }
                                        await _signInWithPhoneNumber().catchError((e){
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      }),
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
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
        ))
    );
  }
}
