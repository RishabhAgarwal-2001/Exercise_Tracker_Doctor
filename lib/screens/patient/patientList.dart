import 'package:flutter/material.dart';

class PatientTable extends StatelessWidget{
  static const String _title = 'Day Wise Schedule';
  List<dynamic> apiResponse;

  PatientTable({this.apiResponse});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.amberAccent),
            columnSpacing: 20,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Day #',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Exercise Name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Patient',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Relative',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ),
            ],
            rows: apiResponse.map(
                (item) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text('${item["today_day"]}')),
                    DataCell(Text('${item["exercise_name"].toString().toUpperCase()}')),
                    item["marked_by_patient"] == 1? DataCell(Icon(Icons.check)) : DataCell(Icon(Icons.clear)),
                    item["marked_by_relative"] == 1? DataCell(Icon(Icons.check)) : DataCell(Icon(Icons.clear)),
                  ]
                )
            ).toList(),
        )
        ),
      ),
    );
  }

}