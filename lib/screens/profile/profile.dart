import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';


class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.black.withOpacity(0.7)),
              clipper: getClipper(),
            ),
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 10,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    Text(
                      'Tom Cruise',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'Mission Impossible',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 30.0,
                            width: 95.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    'Edit Name',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(width: 25.0),
                        Container(
                            height: 30.0,
                            width: 95.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.red,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Divider(height: 30,),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new CircularPercentIndicator(
                        radius: 200.0,
                        animation: true,
                        animationDuration: 1200,
                        lineWidth: 10.0,
                        percent: 30/48,
                        center: new Text(
                          "30 / 48",
                          style:
                          new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor: Colors.red,
                        progressColor: Colors.green,
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }

}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 5);
    path.lineTo(size.width, size.height / 5);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}