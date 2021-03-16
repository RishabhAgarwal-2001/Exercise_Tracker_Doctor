import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/screens/login/OTP/otpEnter.dart';
import 'package:exercise_tracker_doctor/widgets/IconImages.dart';
import 'package:menu_button/menu_button.dart';
import 'package:exercise_tracker_doctor/widgets/buttons.dart';

class WelcomeBoarding extends StatefulWidget {
  @override
  _WelcomeBoardingState createState() => _WelcomeBoardingState();
}

class _WelcomeBoardingState extends State<WelcomeBoarding> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedBoarding;
  bool _autoValidate = false;

  List<String> boardingAS = [
    'Doctor',
    'Staff',
  ];

  String mobNumber = "";
  TextEditingController _mobNumber;


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

  @override
  void initState() {
    selectedBoarding = boardingAS[0];
    _mobNumber = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mobNumber.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final Widget button = SizedBox(
      width: MediaQuery.of(context).size.width/1.7,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                selectedBoarding,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ),
            SizedBox(
                width: 17,
                height: 17,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ))),
          ],
        ),
      ),
    );


    return Scaffold(
//      backgroundColor: Color.fromRGBO(38,38,38,1),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Center(
                    child: Container(
                      height: 147,
                      width: 147,
                      child: TreatmentIconLogo(),
                    ),
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Expanded(
                          flex: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: AutoSizeText.rich(
                              TextSpan(
                                  text: "Hi, Welcome to ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Exercise Tracker",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(108, 71, 145, 1)
                                        )
                                    ),
                                    TextSpan(
                                        text: " Partners",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300
                                        )
                                    )
                                  ]
                              ),
                              maxLines: 1,
                              minFontSize: 5,
                              maxFontSize: 20,
                              style: TextStyle(
                                  fontSize: 30
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: AutoSizeText(
                                  "Boarding as",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              MenuButton(
                                child: button,
                                items: boardingAS,
                                topDivider: true,
                                itemBuilder: (value) => Container(
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black.withOpacity(0.5)),

                                    )),
                                toggledChild: Container(
                                  color: Colors.white,
                                  child: button,
                                ),
                                divider: Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                onItemSelected: (value) {
                                  setState(() {
                                    selectedBoarding = value;
                                  });
                                },

                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]),
                                    borderRadius: const BorderRadius.all(Radius.circular(22.5)),
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                          ),
                        ),
                        Expanded(
                            flex: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30,right: 30),
                              child: Form(
                                autovalidate: _autoValidate,
                                key: _formKey,
                                child: new TextFormField(
                                  validator: _mobileValidator,
                                  onSaved: (String val){
                                    mobNumber = val;
                                  },
                                  keyboardType: TextInputType.phone,
                                  controller: _mobNumber,
                                  style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 16),
                                  decoration: new InputDecoration(
                                    prefixText: "+91",
                                    prefixStyle: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 16),
                                    contentPadding: const EdgeInsets.only(bottom: 12,left: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(22.5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(22.5),
                                      ),
                                    ),
                                    //filled: true,
                                    hintStyle: new TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 12),
                                    hintText: "Enter your contact number",
                                    //fillColor: Colors.white
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            )
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 100,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 25,right: 25,top: 2,bottom: 2),
                              child: purpleButton("GET OTP",function: (){
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> OtpVerification(
                                    mobileNumber: mobNumber,
                                    userType: boardingAS.indexOf(selectedBoarding),
                                  )));
                                } else {
                                  setState(() {
                                    _autoValidate = true;

                                  });
                                }
                              })
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: AutoSizeText.rich(TextSpan(
                                text: "By proceeding you also agree to the ",
                                style: TextStyle(color: Colors.black.withOpacity(0.5)),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Terms and Services ",
                                      style: TextStyle(color: Colors.blueAccent.withOpacity(0.5))
                                  ),
                                  TextSpan(
                                      text: "and ",
                                      style: TextStyle(color: Colors.black.withOpacity(0.5))
                                  ),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(color: Colors.blueAccent.withOpacity(0.5))
                                  ),
                                ]
                            ),maxLines: 2,
                              textAlign: TextAlign.center,
                              maxFontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(),
                        )

                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }


}

