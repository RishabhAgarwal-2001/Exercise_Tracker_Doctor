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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

String dailyExerciseTracking = "Daily Exercise Tracking";
String questionnaire = "Feedback";
String referees = "Collaborators";
String callPatient = "Call Patient";
String messagePatient = "SMS Patient";

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
  List<dynamic> apiResponse, apiResponseStaff;
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  String staff1, staff2;
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
    await getStaffDetails();
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
                        height: 5,
                      ),
                      Text(
                        "Enter Pre-Registered Numbers Only",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto",
                          fontSize: 12,
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
                            onPressed: () async {
                              print("Key Pressed");
                              if(_formKey1.currentState.validate()) {
                                Navigator.of(context).pop();
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  debugPrint("Calling Update API");
                                  await userService.updateStaffNumber(widget.patient.treatmentId, _textFieldController1.text, _textFieldController2.text);
                                  debugPrint("Update Call Success... Getting Details");
                                  await getStaffDetails();
                                  setState(() {
                                    isLoading = false;
                                  });
                                } catch(err) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  debugPrint("Unable to Update or Get Staff");
                                }
                              }
                            },
                            child: Text("UPDATE"),
                          ),
                          FlatButton(
                            onPressed: () {
                              debugPrint("Resetting Controllers");
                              _textFieldController1.text = staff1;
                              _textFieldController2.text = staff2;
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
    if(value=="") return null;
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
    print('Response = $response');
    apiResponseStaff = json.decode(response);
    if(apiResponseStaff.length>=1) {
      staff1 = apiResponseStaff[0]["mobile_number"];
      _textFieldController1.text = staff1;
    } else {
      staff1 = "";
      _textFieldController1.text = staff1;
    }
    if(apiResponseStaff.length>=2) {
      staff2 = apiResponseStaff[1]["mobile_number"];
      _textFieldController2.text = staff2;
    } else {
      staff2 = "";
      _textFieldController2.text = staff2;
    }
    print("I am Here");
  }

  @override
  void initState() {
    super.initState();
    userService = UserTypeService();
    isLoading = false;
    exercisesDone = 0;
    exercisesMissed = 0;
    staff1 = "";
    staff2 = "";
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
        slivers: [
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
      sliver: SliverToBoxAdapter(
        child: CarouselSlider(
          options: CarouselOptions(height: 150.0),
          items: [1, 2, 3].map((i){
            return Builder(
              builder: (BuildContext context) {
                return FittedBox(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image(image: AssetImage('assets/Images/b$i.png')),
                          i==1 ? Positioned(
                              top: 20,
                              right: 23,
                              child: CircleAvatar(
                                  backgroundColor:(Colors.orange),
                                  radius: MediaQuery.of(context).size.width * 0.19,
                                  child: Center(
                                      child: Text(
                                          "${widget.patient.treatmentDay}/${widget.patient.totalTreatmentLength}",
                                          style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35)
                                      )
                                  )
                              )
                          ) : (i==2 ? Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                                height: (MediaQuery.of(context).size.width),
                                width: (MediaQuery.of(context).size.width)*0.35,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    color: i==2 ? Color(0xFF611C61) : Color(
                                        0xFF0855A7)
                                ),
                                child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          i==2 ? "EXERCISES DONE" : "EXERCISES MISSED",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          i==2 ? "${exercisesDone}/${exercisesDone+exercisesMissed}"
                                              : "${exercisesMissed}/${exercisesDone+exercisesMissed}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        )
                                      ],
                                    )
                                )
                            ) ,
                          ) : Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                                height: (MediaQuery.of(context).size.width),
                                width: (MediaQuery.of(context).size.width)*0.35,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    color: i==2 ? Color(0xFF611C61) : Color(
                                        0xFF0855A7)
                                ),
                                child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          i==2 ? "EXERCISES DONE" : "EXERCISES MISSED",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          i==2 ? "${exercisesDone}/${exercisesDone+exercisesMissed}"
                                              : "${exercisesMissed}/${exercisesDone+exercisesMissed}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        )
                                      ],
                                    )
                                )
                            ) ,
                          )),
                          i==1 ? Positioned(
                              top: 5,
                              left: MediaQuery.of(context).size.width*0.3,
                              child: Text('TREATMENT\nDAYS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ))
                          ) : Container()
                        ],
                      )
                  ),
                  fit: BoxFit.fill,
                );
              }
            );
          }).toList()
        )
      ),
    );
    // return SliverPadding(
    //   padding: const EdgeInsets.all(16.0),
    //   sliver: SliverGrid.count(
    //     crossAxisSpacing: 16.0,
    //     mainAxisSpacing: 16.0,
    //     childAspectRatio: 1,
    //     crossAxisCount: 3,
    //     children: <Widget>[
    //       Container(
    //         padding: const EdgeInsets.all(8.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10.0),
    //           color: Colors.blue,
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             FittedBox(
    //               fit: BoxFit.fitWidth,
    //               child: Text(
    //                 "${widget.patient.treatmentDay}/${widget.patient.totalTreatmentLength}",
    //                 style: stats,
    //               ),
    //             ),
    //             const SizedBox(height: 5.0),
    //             FittedBox(
    //               fit: BoxFit.fitWidth,
    //               child: Text("Treatment Days".toUpperCase())
    //             )
    //
    //
    //           ],
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.all(8.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10.0),
    //           color: Colors.pink,
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             FittedBox(
    //               fit: BoxFit.fitWidth,
    //               child: Text(
    //                 "${exercisesMissed}/${exercisesMissed+exercisesDone}",
    //                 style: stats,
    //               ),
    //             ),
    //             const SizedBox(height: 5.0),
    //             FittedBox(
    //                 fit: BoxFit.fitWidth,
    //                 child: Text("Exercises Missed".toUpperCase())
    //             )
    //
    //
    //           ],
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.all(8.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10.0),
    //           color: Colors.green,
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             FittedBox(
    //               fit: BoxFit.fitWidth,
    //               child: Text(
    //                 "${exercisesDone}/${exercisesDone+exercisesMissed}",
    //                 style: stats,
    //               ),
    //             ),
    //             const SizedBox(height: 5.0),
    //             FittedBox(
    //                 fit: BoxFit.fitWidth,
    //                 child: Text("Exercises Done".toUpperCase())
    //             )
    //
    //
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
                                      widget.patient.treatmentDay,
                                      widget.patient.name,
                                      widget.patient.latestFeedbackDate
                                  ),
                            ),
                          );
                        } else if(activity.title==referees) {
                          _showDialog();
                        } else if(activity.title==callPatient) {
                          UrlLauncher.launch('tel://${widget.patient.mobile}');
                        } else if(activity.title==messagePatient) {
                          UrlLauncher.launch('sms://${widget.patient.mobile}');
                        }
                      },
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      activity.title==questionnaire?'${activity.title}\n(${widget.patient.countFeedbackFilled})':activity.title,
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

class DonutPieChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final List<charts.Series> patient;
  final List<charts.Series> patientRelative;
  final bool animate;

  DonutPieChart(this.seriesList, this.patient, this.patientRelative, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData(List<dynamic> apiResponse) {
    List<List<charts.Series>> res = _createSampleData(apiResponse);
    return new DonutPieChart(
      res[0],
      res[1],
      res[2],
      animate: true,
    );
  }

  @override
  _DonutPieChartState createState() => _DonutPieChartState();

  static List<List<charts.Series<LinearSales, String>>> _createSampleData(List<dynamic> apiResponse) {

    Map map = Map<String, int>();
    Map map1 = Map<String, int>();
    Map map2 = Map<String, int>();

    var lengthOfList = apiResponse==null ? 0 : apiResponse.length;

    for(var i=0; i< lengthOfList; i++) {
      if(map.containsKey(apiResponse[i]["exercise_name"].toString().toUpperCase())) {
        map[apiResponse[i]["exercise_name"].toString().toUpperCase()]++;
      } else {
        map[apiResponse[i]["exercise_name"].toString().toUpperCase()] = 1;
      }
      if(apiResponse[i]["marked_by_patient"]==1) {
        if(map1.containsKey(apiResponse[i]["exercise_name"].toString().toUpperCase())) {
          map1[apiResponse[i]["exercise_name"].toString().toUpperCase()]++;
        } else {
          map1[apiResponse[i]["exercise_name"].toString().toUpperCase()] = 1;
        }
      }
      if(apiResponse[i]["marked_by_patient"]==1 && apiResponse[i]["marked_by_relative"]==1) {
        if(map2.containsKey(apiResponse[i]["exercise_name"].toString().toUpperCase())) {
          map2[apiResponse[i]["exercise_name"].toString().toUpperCase()]++;
        } else {
          map2[apiResponse[i]["exercise_name"].toString().toUpperCase()] = 1;
        }
      }
    }

    List<LinearSales>data = [];
    List<LinearSales>data1 = [];
    List<LinearSales>data2 = [];

    map.forEach((key, value) {
      data.add(LinearSales("${key.toString()[0]}${key.toString().substring(1).toLowerCase()}", value));
    });

    map1.forEach((key, value) {
      data1.add(LinearSales("${key.toString()[0]}${key.toString().substring(1).toLowerCase()}", value));
    });

    map2.forEach((key, value) {
      data2.add(LinearSales("${key.toString()[0]}${key.toString().substring(1).toLowerCase()}", value));
    });

    print("Map => ${map}");
    print("Map1 => ${map1}");
    print("Map2 => ${map2}");

    return [
      [
      new charts.Series<LinearSales, String>(
        id: 'Exercises',
        domainFn: (LinearSales sales, _) => sales.exercise,
        measureFn: (LinearSales sales, _) => sales.count,
        data: data,
      )
      ],
      [
        new charts.Series<LinearSales, String>(
          id: 'Exercises1',
          domainFn: (LinearSales sales, _) => sales.exercise,
          measureFn: (LinearSales sales, _) => sales.count,
          data: data1,
        )
      ],
      [
        new charts.Series<LinearSales, String>(
          id: 'Exercises2',
          domainFn: (LinearSales sales, _) => sales.exercise,
          measureFn: (LinearSales sales, _) => sales.count,
          data: data2,
        )
      ]
    ];
  }
}

class _DonutPieChartState extends State<DonutPieChart> {
  List<LinearSales> dataList;
  String selectedExercise, selectedCount;
  bool assigned = true;
  bool patient = false;
  bool patientRelative = false;

  @override
  void initState() {
    super.initState();
    selectedExercise = "No Exercise Selected";
    selectedCount = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container (
        child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top:10, right:80),
            child: new charts.PieChart(
              assigned ? widget.seriesList : (patient ? widget.patient : widget.patientRelative),
              animate: widget.animate,
              selectionModels: [
                charts.SelectionModelConfig(
                    changedListener: (charts.SelectionModel model) {
                      if(model.hasDatumSelection) {
                        setState(() {
                          selectedExercise = model.selectedSeries[0].domainFn(model.selectedDatum[0].index).toString();
                          selectedCount = model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
                        });
                      }
                    }
                )
              ],
              behaviors: [
                new charts.DomainHighlighter(),
                new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag)
              ],
              defaultInteractions: true,
            ),),
          Container(
            child: Text(
                '${selectedExercise}\n${selectedCount}',
                style: TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          Positioned(
            right: 0,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    child:ToggleButtons(
                      borderColor: Colors.blueAccent,
                      fillColor: Colors.blueAccent,
                      borderWidth: 1,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          'ASSIGNED',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ],
                      onPressed: (int index) {
                        if(!assigned) {
                          setState(() {
                            assigned = true;
                            patient = false;
                            patientRelative = false;
                            if(widget.seriesList.length==0) {
                              selectedExercise = "No Data Found";
                              selectedCount = "";
                            }
                          });
                        }
                      },
                      isSelected: [assigned],
                )),
                Container(
                    padding: EdgeInsets.all(5),
                    child:ToggleButtons(
                      borderColor: Colors.blueAccent,
                      fillColor: Colors.blueAccent,
                      borderWidth: 1,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            'PATIENT',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        if(!patient) {
                          setState(() {
                            assigned = false;
                            patient = true;
                            patientRelative = false;
                            if(widget.patient.length==0) {
                              selectedExercise = "No Data Found";
                              selectedCount = "";
                            }
                          });
                        }
                      },
                      isSelected: [patient],
                    )),
                Container(
                    padding: EdgeInsets.all(5),
                    child:ToggleButtons(
                      borderColor: Colors.blueAccent,
                      fillColor: Colors.blueAccent,
                      borderWidth: 1,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            'PATIENT\n+\nRELATIVE',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        if(!patientRelative) {
                          setState(() {
                            assigned = false;
                            patient = false;
                            patientRelative = true;
                            if(widget.patientRelative.length==0) {
                              selectedExercise = "No Data Found";
                              selectedCount = "";
                            }
                          });
                        }
                      },
                      isSelected: [patientRelative],
                    )),
              ],
            ),
          )
        ]
    ));
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
  Activity(title: referees, icon: FontAwesomeIcons.users),
  Activity(title: callPatient, icon: FontAwesomeIcons.phone),
  Activity(title: messagePatient, icon: FontAwesomeIcons.facebookMessenger)
];

