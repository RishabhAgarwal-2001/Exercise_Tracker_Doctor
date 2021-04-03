import 'package:exercise_tracker_doctor/constants.dart';
import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/models/Patient.dart';
import 'package:badges/badges.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PatientCard extends StatelessWidget {

  const PatientCard({
    Key key,
    this.patient,
    this.press
  });

  final Patient patient;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: InkWell(
        onTap: press,
        child: Container(
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: kBgLightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Badge(
                              badgeColor: patient.isDoingExerciseOnTime?
                              Colors.green:
                              Colors.red,
                              position: BadgePosition.topEnd(),
                              shape: BadgeShape.circle,
                              borderRadius: BorderRadius.circular(100),
                              badgeContent: Container(
                                height: 3,
                                width: 3,
                                decoration:
                                BoxDecoration(shape: BoxShape.circle, color: patient.isDoingExerciseOnTime?
                                Colors.green:
                                Colors.red),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                // TODO: Add Image From API
                                backgroundImage: AssetImage(patient.image !=null ? patient.image : "assets/Images/person8.png"),
                              ),
                            )
                          ),
                          SizedBox(width: kDefaultPadding),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                  text: "${patient.name} \n",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black
                                  ),
                                children: [
                                  TextSpan(
                                    text: "${patient.operation}",
                                    style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                      color: kTextColor
                                    )
                                  )
                                ]
                              )
                            )
                          ),
                          CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 2.5,
                            percent: patient.treatmentDay/patient.totalTreatmentLength,
                            center: new Text("${(100*(patient.treatmentDay/patient.totalTreatmentLength)).round()}%", style: TextStyle(fontSize: 10)),
                            progressColor: Colors.green,
                          ),
                          SizedBox(width: kDefaultPadding,),
                          Icon(patient.criticalStatus?
                            Icons.clear:
                            Icons.check,
                            color: patient.criticalStatus?
                            Colors.red:
                            Colors.green,
                            size: 32
                          )
                        ]
                    )
                  ],
                )
            )
        )
    );
  }

}