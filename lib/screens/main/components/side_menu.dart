import 'package:exercise_tracker_doctor/constants.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/constants.dart';

class SideMenu extends StatelessWidget {

  final Function(int) notifyParent;

  const SideMenu({
    Key key, @required this.notifyParent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Dr. Roberto Aleydon'),
              accountEmail: Text('aleydon@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/Images/vk.png'),
              ),

              // TODO: Implement this to show details of the Doctor
              onDetailsPressed: (){},

            ),

            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onLongPress: (){},
            ),


            Divider(),

            ListTile(
              title: Text('Patient Filters',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                )
              ),
              leading: Icon(Icons.filter_alt_outlined),
            ),

            ListTile(
              title: Text('All Patients'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pop();
                notifyParent(1);
              }
            ),

            ListTile(
              title: Text('On Schedule'),
              leading: Icon(Icons.schedule),
              onTap: () {
                Navigator.of(context).pop();
                notifyParent(2);
              }
            ),

            ListTile(
              title: Text('Off Schedule'),
              leading: Icon(Icons.assignment_late),
              onTap: () {
                Navigator.of(context).pop();
                notifyParent(3);
              }
            ),


            ListTile(
              title: Text('Critical Status'),
              leading: Icon(Icons.clear),
              onTap: () {
                Navigator.of(context).pop();
                notifyParent(4);
              }
            ),

            ListTile(
              title: Text('Treatment Completed'),
              leading: Icon(Icons.done_all),
              onTap: () {
                Navigator.of(context).pop();
                notifyParent(5);
              }
            ),


            Divider(),


            ListTile(
              title: Text('Support'),
              leading: Icon(Icons.report_problem),
              onLongPress: (){},
            ),


            ListTile(
                title: Text('Close'),
                leading: Icon(Icons.close),
                onTap: (){
                  Navigator.of(context).pop();}
            ),
          ]
      ),
    );
  }
  
}