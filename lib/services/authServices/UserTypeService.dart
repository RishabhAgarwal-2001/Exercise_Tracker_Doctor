import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class UserTypeService{

  static final UserTypeService _singleton = UserTypeService._internal();
  factory UserTypeService() {
    return _singleton;
  }
  UserTypeService._internal();




  int userType = -1;
  String jwtToken = "";
  int userRegistered = -1;


  static String baseUrl = "https://treatment-application-dep.herokuapp.com";

  List<String> loginAPI = [
    baseUrl+"/api/v1/users/login",
  ];
  List<String> registerAPI = [
    baseUrl+"/api/v1/register/doctor",
    baseUrl+"/api/v1/register/staff"
  ];
  List<String> patientAPI = [
    baseUrl+"/api/v1/doctor/get_all_patients",
    baseUrl+"/api/v1/doctor/get_one_patient",
    baseUrl+"/api/v1/doctor/star",
    baseUrl+"/api/v1/questionnaire/get_doctor/questionnaire",
    baseUrl+"/api/v1/doctor/critical",
  ];
  List<String> addPatientAPI = [
    baseUrl + "/api/v1/treatment/week_1_2",
    baseUrl + "/api/v1/treatment/week_3_1",
    baseUrl + "/api/v1/treatment/week_4_5",
    baseUrl + "/api/v1/treatment/week_6",
    baseUrl + "/api/v1/treatment/week_3_2"
  ];
  List<String> doctorProfileAPI = [
    baseUrl + "/api/v1/doctor/get_doctor_profile",
    baseUrl + "/api/v1/doctor/update_doctor_profile"
  ];
  List<String> handleStaffAPI = [
    baseUrl + "/api/v1/doctor/getStaff"
  ];

  Future<void> setUserRegistered(int status)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('registered',status);
  }

  Future<void> checkUserRegistered() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRegistered = (prefs.getInt('registered') ?? -1);
  }

  Future<void> checkUserType() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = (prefs.getInt('type') ?? -1);
  }

  Future<void> setUserType(int type)async{
    userType = type;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('type',type);
  }

  Future<String> getAuthIdToken() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    IdTokenResult authId = await user.getIdToken();
    return authId.token.toString();
  }

  Future<String> getUID() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    return uid;
  }


  Future<void> checkJWTToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken = (prefs.getString('jwt') ?? "");
    //jwtToken = "";
  }

  Future<void> setJWTToken(String token)async{
    jwtToken = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt',token);
  }


  Future<int> setRole(FirebaseUser user,String mobileNumber)async{
    await checkUserType();
    if(userType==-1) throw Error();

    String authId  = await getAuthIdToken();

    Map<String, String> requestBody = {
      "mobile_number": mobileNumber,
      "user_type" : (userType == 0) ? "d" : "s",
      "auth_token" : authId
    };
    print("sending req");
    var response;
    try{
      response = await http.post(
        loginAPI[0],
        body: requestBody,
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    if(response.statusCode == 200){
      setUserRegistered(200);
    }
    print("Response Body ${response.body}");
    await setJWTToken(json.decode(response.body)["token"]);
    print(response.statusCode);
    return response.statusCode;
//    if (response.body.split(" ")[0] != "Registered"){
//      throw Error();
//    }


  }
  Future<int> registerDoctor(String firstName, String lastName,String department,String designation,String hospital)async{
    print("I am here");
    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();

    Map<String, String> requestBody = {
      "designation": designation,
      "department" : department,
      "hospital":hospital,
      "x-access-token" : jwtToken,
      "first_name" : firstName,
      "last_name" : lastName
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    print("sending req");
    var response;
    try{
      response = await http.post(
        registerAPI[0],
        body: requestBody,
        headers: requestHeaders
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    if(response.statusCode == 200){
      setUserRegistered(200);
    }
    print(response.body);
    print(response.statusCode);
    return response.statusCode;

  }

  Future<int> registerStaff(String firstName, String lastName,String department,String designation,String hospital)async{
    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();

    Map<String, String> requestBody = {
      "designation": designation,
      "department" : department,
      "hospital":hospital,
      "x-access-token" : jwtToken,
      "first_name" : firstName,
      "last_name" : lastName
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    print("sending req");
    var response;
    try{
      response = await http.post(
        registerAPI[1],
        body: requestBody,
        headers: requestHeaders
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    if(response.statusCode == 200){
      setUserRegistered(200);
    }
    print(response.body);
    print(response.statusCode);
    return response.statusCode;

  }

  Future<String> getPatients() async{
    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();
    Map<String, String> requestBody = {
      "x-access-token" : jwtToken,
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    var response;
    try{
      response = await http.get(
          patientAPI[0],
          headers: requestHeaders
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    print(response.body);
    print(response.statusCode);
    return response.body.toString();

  }

  Future<String> getOnePatient(String mobileNumber) async {
    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();


    Map<String, String> requestBody = {
      "x-access-token" : jwtToken,
      "mobile_number": mobileNumber
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    var response;
    print("Making a Request for patient details...");
    try{
      response = await http.post(
          patientAPI[1],
          body: requestBody,
          headers: requestHeaders
      );
    }
    catch(e){
      print("This is the error => ${e}");
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    print(response.body);
    print(response.statusCode);
    return response.body.toString();

  }

  Future<int> addPatient(String mobileNumber, String startDate, String endDate,String staff1,String staff2)async{
    print("Inside Function to Add Patient");

    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();

    Map<String, String> requestBody = {
      "mobile_number": mobileNumber,
      "start_date" : startDate,
      "end_date":endDate,
      "staff1": staff1,
      "staff2": staff2,
      "x-access-token" : jwtToken,
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    print(requestBody);
    print(requestHeaders);
    print("sending req 1");
    var response;
    try{
      response = await http.post(
          addPatientAPI[0],
          body: requestBody,
          headers: requestHeaders
      );
    }
    catch(e){
      print(e);
    }
    print("Response 1 Received");
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    String treatmentID;
    print(response.statusCode);
    print(response.statusCode.runtimeType);
    print(response.body);
    if(response.statusCode == 200){
      print("I am Here");
      print(json.decode(response.body));
      treatmentID = json.decode(response.body)["treatmentID"];
      print("treatmentID => ${treatmentID}");
    }
    requestBody["treatmentID"] = treatmentID;
    try{
      print('Sending request 2.1');
      response = await http.post(
          addPatientAPI[1],
          body: requestBody,
          headers: requestHeaders
      );
    } catch(e) {
      print(e);
    }
    print("Response 2.1 Received");
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    try{
      print('Sending request 2.2');
      response = await http.post(
          addPatientAPI[4],
          body: requestBody,
          headers: requestHeaders
      );
    } catch(e) {
      print(e);
    }
    print("Response 2.2 Received");
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    try{
      print('Sending request 3');
      response = await http.post(
          addPatientAPI[2],
          body: requestBody,
          headers: requestHeaders
      );
    } catch(e) {
      print(e);
    }
    print("Response 3 Received");
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    try{
      print('Sending request 4');
      response = await http.post(
          addPatientAPI[3],
          body: requestBody,
          headers: requestHeaders
      );
    } catch(e) {
      print(e);
    }
    print("Response 4 Received");
    print(response.body);
    print(response.statusCode);
    return response.statusCode;

  }

  Future<String> pinPatient(String mobileNumber, int star) async{
    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();
    Map<String, String> requestBody = {
      "x-access-token" : jwtToken,
      "mobile_number" : mobileNumber,
      "star": star.toString()
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    var response;
    try{
      response = await http.post(
          patientAPI[2],
          headers: requestHeaders,
          body: requestBody
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    print(response.body);
    print(response.statusCode);
    return response.statusCode.toString();

  }

  Future<String> getQuestionResponse(String mobileNumber, int day) async{
    print("Getting Question Started...");
    print("Mobile NUmber: ${mobileNumber}");
    print("Treatment Day: ${day}");
    await checkUserType();
    if(userType==-1) throw Error();

    await checkJWTToken();
    Map<String, String> requestBody = {
      "x-access-token" : jwtToken,
      "mobile_number" : mobileNumber,
      "day": day.toString()
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    var response;
    try{
      response = await http.post(
          patientAPI[3],
          headers: requestHeaders,
          body: requestBody
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    print(response.body);
    print(response.statusCode);
    return response.body.toString();

  }

  Future<String> setCriticalStatus(String mobileNumber, bool setStatus) async{
    print("Setting Criticality Status...");
    print("Mobile NUmber: ${mobileNumber}");
    print("Status: ${setStatus}");
    await checkUserType();
    if(userType==-1) throw Error();
    await checkJWTToken();
    Map<String, String> requestBody = {
      "x-access-token" : jwtToken,
      "mobile_number" : mobileNumber,
      "critical": setStatus ? "1" : "0",
    };
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    var response;
    try{
      response = await http.post(
          patientAPI[4],
          headers: requestHeaders,
          body: requestBody
      );
    }
    catch(e){
      print(e);
    }
    print("Status Code : ${response.statusCode}");
    if(response.statusCode == 400){
      print("Error in response");
      print(response.body);
      throw new Error();
    }
    print(response.body);
    print("Status Code : ${response.statusCode}");
    return response.statusCode.toString();
  }

  Future<String> getDoctorProfile() async {
    await checkUserType();
    if(userType==-1) throw Error();
    await checkJWTToken();
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    var response;
    try{
      response = await http.get(
          doctorProfileAPI[0],
          headers: requestHeaders
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response From Getting Doctor Profile");
      print(response.body);
      throw new Error();
    }
    return response.statusCode==200?response.body:"{}";
  }

  Future<String> getStaffNumber(String treatmentId) async {
    print("Getting Staff number");
    await checkUserType();
    if(userType==-1) throw Error();
    await checkJWTToken();
    Map<String, String> requestHeaders = {
      'x-access-token': jwtToken
    };
    print("Token ${jwtToken}");
    Map<String, String> requestBody = {
      'treatmentID': treatmentId
    };
    var response;
    try{
      response = await http.post(
          handleStaffAPI[0],
          headers: requestHeaders,
          body: requestBody
      );
    }
    catch(e){
      print(e);
    }
    if(response.statusCode == 400){
      print("Error in response From Getting Doctor Profile");
      print(response.body);
      throw new Error();
    }
    return response.statusCode==200?response.body:"{}";
  }

}


