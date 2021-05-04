import 'package:exercise_tracker_doctor/screens/patient/questions.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/models/Patient.dart';
import 'package:exercise_tracker_doctor/services/authServices/UserTypeService.dart';
// import 'package:flutter_ui_challenges/src/pages/animations/animation1/animation1.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:exercise_tracker_doctor/screens/patient/patientList.dart';
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;

String dailyExerciseTracking = "Daily Exercise Tracking";
String questionnaire = "Feedback";
String referees = "Collaborators";

class DashboardOnePage extends StatefulWidget {
  // static final String path = "lib/src/pages/dashboard/dash1.dart";
  //
  // final String image = images[0];

  final Patient patient;

  DashboardOnePage({
    Key key,
    this.patient
  });

  @override
  _DashboardOnePageState createState() => _DashboardOnePageState();
}

class _DashboardOnePageState extends State<DashboardOnePage> {

  UserTypeService userService;
  bool isLoading;
  int exercisesMissed;
  int exercisesDone;
  List<dynamic> apiResponse;
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();



  Future<void> getPatientDetails() async {
    this.setState(() {
      isLoading = true;
    });
    String response = await userService.getOnePatient(widget.patient.mobile);
    apiResponse = json.decode(response);
    for(var i=0; i<apiResponse.length; i++) {
      if(apiResponse[i]["marked_by_patient"]==1 && apiResponse[i]["marked_by_relative"]==1) {
        exercisesDone++;
      } else {
        exercisesMissed++;
      }
    }
    // await getStaffDetails();
    this.setState(() {
      isLoading = false;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: Container(
                height: 0.35 * MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey1,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Manage Collaborators",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto",
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _textFieldController1,
                        decoration: InputDecoration(prefixText: "+91 ",
                            hintText: "Phone Number 1"),
                        validator: _phoneNumberValidator,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _textFieldController2,
                        decoration: InputDecoration(prefixText: "+91 ",
                            hintText: "Phone Number 2"),
                        validator: _phoneNumberValidator,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              print("Key Pressed");
                              if(_formKey1.currentState.validate()) {
                                // TODO: Update the Staff Number
                                // TODO: Create and Update Local Variables
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("UPDATE"),
                          ),
                          FlatButton(
                            onPressed: () {
                              // TODO: Reset TextControllers to Original Number
                              Navigator.of(context).pop();
                            },
                            child: Text("CANCEL"),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ),
            ),
          ),
        );
      },
    );
  }

  String _phoneNumberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  Future<void> getStaffDetails() async {
    print('Sending Request For Staff Number');
    String response = await userService.getStaffNumber(widget.patient.treatmentId);
    print(response);
    // apiResponse = json.decode(response);
    // for(var i=0; i<apiResponse.length; i++) {
    //   if(apiResponse[i]["marked_by_patient"]==1 && apiResponse[i]["marked_by_relative"]==1) {
    //     exercisesDone++;
    //   } else {
    //     exercisesMissed++;
    //   }
    // }
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    userService = UserTypeService();
    isLoading = false;
    exercisesDone = 0;
    exercisesMissed = 0;
    getPatientDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).buttonColor,
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        ),
        isLoading == true ? Container(
          color: Colors.black.withOpacity(0.5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator(),)) : Container()]
    );
  }

  _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildStats(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTitledContainer("Exercises",
                child: Container(
                    height: 200, child: DonutPieChart.withSampleData(apiResponse))),
          ),
        ),
        _buildActivities(context),
      ],
    );
  }

  SliverPadding _buildStats() {
    final TextStyle stats = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${widget.patient.treatmentDay}/${widget.patient.totalTreatmentLength}",
                    style: stats,
                  ),
                ),
                const SizedBox(height: 5.0),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("Treatment Days".toUpperCase())
                )


              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.pink,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${exercisesMissed}/${exercisesMissed+exercisesDone}",
                    style: stats,
                  ),
                ),
                const SizedBox(height: 5.0),
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text("Exercises Missed".toUpperCase())
                )


              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${exercisesDone}/${exercisesDone+exercisesMissed}",
                    style: stats,
                  ),
                ),
                const SizedBox(height: 5.0),
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text("Exercises Done".toUpperCase())
                )


              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildActivities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: _buildTitledContainer(
          "Activities",
          height: 280,
          child: Expanded(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: activities
                  .map(
                    (activity) => Column(
                  children: <Widget>[
                    InkWell(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).buttonColor,
                        child: activity.icon != null
                            ? Icon(
                          activity.icon,
                          size: 18.0,
                        )
                            : null,
                      ),
                      onTap: () {
                        if(activity.title==dailyExerciseTracking) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PatientTable(apiResponse: apiResponse,),
                            ),
                          );
                        } else if(activity.title==questionnaire) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionsResponse(
                                      widget.patient.mobile,
                                      widget.patient.treatmentDay
                                  ),
                            ),
                          );
                        } else if(activity.title==referees) {
                          _showDialog();
                        }
                      },
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      activity.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Images/vk.png"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20.0)),
              height: 200,
              foregroundDecoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20.0)),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Good Afternoon".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Take a glimpses at your dashboard",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      titleSpacing: 0.0,
      elevation: 0.5,
      backgroundColor: Colors.white,
      title: Text(
        "${widget.patient.name}",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[_buildAvatar(context)],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return IconButton(
      iconSize: 40,
      padding: EdgeInsets.all(0),
      icon: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: CircleAvatar(radius: 16, backgroundImage: AssetImage(widget.patient.image !=null ? widget.patient.image : "assets/Images/person8.png")),
      ),
      onPressed: () {},
    );
  }

  Container _buildTitledContainer(String title, {Widget child, double height}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  List<LinearSales> dataList;

  DonutPieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData(List<dynamic> apiResponse) {
    return new DonutPieChart(
      _createSampleData(apiResponse),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
              animate: animate,
              selectionModels: [
                charts.SelectionModelConfig(
                    changedListener: (charts.SelectionModel model) {
                      print(model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
                      print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
                    }
                )
              ],
              behaviors: [
                new charts.DomainHighlighter(),
                new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag)
              ],
              defaultInteractions: true,
            );
  }

  static List<charts.Series<LinearSales, String>> _createSampleData(List<dynamic> apiResponse) {

    Map map = Map<String, int>();

    var lengthOfList = apiResponse==null ? 0 : apiResponse.length;

    for(var i=0; i< lengthOfList; i++) {
      if(map.containsKey(apiResponse[i]["exercise_name"].toString().toUpperCase())) {
        map[apiResponse[i]["exercise_name"].toString().toUpperCase()]++;
      } else {
        map[apiResponse[i]["exercise_name"].toString().toUpperCase()] = 1;
      }
    }

    List<LinearSales>data = [];

    map.forEach((key, value) {
      data.add(LinearSales("${key.toString()[0]}${key.toString().substring(1).toLowerCase()}", value));
    });

    print("Data => ${data}");

    return [
      new charts.Series<LinearSales, String>(
        id: 'Exercises',
        domainFn: (LinearSales sales, _) => sales.exercise,
        measureFn: (LinearSales sales, _) => sales.count,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final String exercise;
  final int count;

  LinearSales(this.exercise, this.count);
}

class Activity {
  final String title;
  final IconData icon;
  Activity({this.title, this.icon});
}

final List<Activity> activities = [
  Activity(title: dailyExerciseTracking, icon: FontAwesomeIcons.listOl),
  Activity(title: questionnaire, icon: FontAwesomeIcons.question),
  Activity(title: referees, icon: FontAwesomeIcons.users)
];

