import 'package:flutter/material.dart';





Widget purpleButton(String st,{Function function, double fontSz = 17.0} ){
  return RaisedButton(
    color: Color.fromRGBO(108, 71, 145, 1),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))

    ),
    onPressed: (){
      if(function!=null) function();
    },
    child: Center(
      child: Text(
        st,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSz
        ),
      ),
    ),
  );
}


Widget greyButton(String st,{Function function} ){
  return RaisedButton(
    color: Colors.grey,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))

    ),
    onPressed: (){
      if(function!=null) function();
    },
    child: Center(
      child: Text(
        st,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17
        ),
      ),
    ),
  );
}