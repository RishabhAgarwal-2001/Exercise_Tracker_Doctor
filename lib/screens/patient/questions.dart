import 'package:flutter/material.dart';
import 'package:exercise_tracker_doctor/services/authServices/UserTypeService.dart';
import 'dart:convert';

class Message {
  final int user;
  final String description;

  Message(this.user, this.description);
}

class QuestionsResponse extends StatefulWidget {

  final String mobileNumber, patientName, feedbackDate;
  final int treatmentDay;

  QuestionsResponse(this.mobileNumber, this.treatmentDay, this.patientName, this.feedbackDate);

  @override
  QuestionsResponseState createState() => QuestionsResponseState();
}

class QuestionsResponseState extends State<QuestionsResponse> {

  bool isLoading = false;
  UserTypeService userService;

  final List<Message> messages = [];


  void getQuestion() async {
    setState(() {
      isLoading = true;
    });
    String response = await userService.getQuestionResponse(widget.mobileNumber, 9);
    List<dynamic> responseConverted = json.decode(response);
    print('Response = ${responseConverted}');
    responseConverted.forEach((element) {
      messages.add(Message(0, element["question"].toString()));
      messages.add(Message(1, element["response"].toString()));
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = false;
    userService = UserTypeService();
    try{getQuestion();}
    catch(err){
      setState(() {
      isLoading = false;
    });}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.feedbackDate=="null" || widget.feedbackDate=="") ?
        Text("${widget.patientName} - Feedback"):
        Text("${widget.patientName} - Feedback\nFilled On: ${DateTime.parse(widget.feedbackDate).day}-${DateTime.parse(widget.feedbackDate).month}-${DateTime.parse(widget.feedbackDate).year}"),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              messages.length!=0 ?
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10.0);
                  },
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    Message m = messages[index];
                    if (m.user == 0) return _buildMessageRow(m, current: true);
                    return _buildMessageRow(m, current: false);
                  },
                ),
              ):
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'No Response Received',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
            ],
          ),
          isLoading == true? Container(
              color: Colors.black.withOpacity(0.5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator(),)):Container(),
        ],
      )

    );
  }

  Row _buildMessageRow(Message message, {bool current}) {
    return Row(
      mainAxisAlignment:
      current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
      current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        ///Chat bubbles
        Container(
          padding: EdgeInsets.only(
            bottom: 5,
            right: 5,
          ),
          child: Column(
            crossAxisAlignment:
            current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  minHeight: 40,
                  maxHeight: 250,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  minWidth: MediaQuery.of(context).size.width * 0.1,
                ),
                decoration: BoxDecoration(
                  color: current ? Colors.blueAccent : Colors.white,
                  borderRadius: current
                      ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                      : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 10, bottom: 5, right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: current
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          message.description,
                          style: TextStyle(
                            color: current ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              )
            ],
          ),
        ),
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }

}
