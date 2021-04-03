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
    baseUrl+"/api/v1/doctor/get_one_patient"
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

}


