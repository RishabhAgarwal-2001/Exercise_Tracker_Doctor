import 'package:exercise_tracker_doctor/constants.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/constants.dart';

class SideMenu extends StatelessWidget {

  const SideMenu({
    Key key,
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
            ),

            ListTile(
              title: Text('On Schedule'),
              leading: Icon(Icons.schedule),
            ),

            ListTile(
              title: Text('Off Schedule'),
              leading: Icon(Icons.assignment_late),
              onLongPress: (){},
            ),


            ListTile(
              title: Text('Critical Status'),
              leading: Icon(Icons.clear),
              onLongPress: (){},
            ),

            ListTile(
              title: Text('Treatment Completed'),
              leading: Icon(Icons.done_all),
              onLongPress: (){},
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