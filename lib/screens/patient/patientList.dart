import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';

class PatientTable extends StatefulWidget{
  static const String _title = 'Day Wise Schedule';
  List<dynamic> apiResponse;

  PatientTable({this.apiResponse});

  @override
  _PatientTableState createState() => _PatientTableState();
}

class _PatientTableState extends State<PatientTable> {
  int _currentSortColumn = 0;
  bool isLoading = false;
  bool _isAscending = true;

  List<String> allExercises = [];
  List<String> selectedExercises = [];
  List<String> allDays = [];
  List<String> selectedDays = [];

  void _openExerciseFilterDialog() async {
    await FilterListDialog.display(
        context,
        listData: allExercises,
        selectedListData: selectedExercises,
        height: 480,
        headlineText: "Filter Exercises",
        searchFieldHintText: "Search Here",
        label: (item) {
          return item;
        },
        validateSelectedItem: (list, val) {
          return list.contains(val);
        },
        onItemSearch: (list, text) {
          if (list.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        },
        onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedExercises = List.from(list);
            });
          }
          Navigator.pop(context);
        });
  }

  void _openDayFilterDialog() async {
    await FilterListDialog.display(
        context,
        listData: allDays,
        selectedListData: selectedDays,
        height: 480,
        headlineText: "Filter Exercises",
        searchFieldHintText: "Search Here",
        label: (item) {
          return item;
        },
        validateSelectedItem: (list, val) {
          return list.contains(val);
        },
        onItemSearch: (list, text) {
          if (list.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        },
        onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedDays = List.from(list);
            });
          }
          Navigator.pop(context);
        });
  }

  void handleSort(int columnIndex, bool ascending) {
    setState(() {
      isLoading = true;
    });
    setState(() {
      if(_currentSortColumn==columnIndex) {
        _isAscending = !_isAscending;
      } else {
        _currentSortColumn = columnIndex;
        _isAscending = true;
      }
      String s = "today_day";
      if(_currentSortColumn==1) {
        s = "exercise_name";
      }
      if(_isAscending) {
        widget.apiResponse.sort((elem1, elem2) => elem2[s].compareTo(elem1[s]));
      } else {
        widget.apiResponse.sort((elem1, elem2) => elem1[s].compareTo(elem2[s]));
      }
      // isLoading = false;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    allExercises = widget.apiResponse.map((item) => item["exercise_name"].toString()).toSet().toList();
    selectedExercises = allExercises;
    allDays = widget.apiResponse.map((item) => item["today_day"].toString()).toSet().toList();
    print('allDays => ${allDays}');
    selectedDays = allDays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: PatientTable._title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text(PatientTable._title),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: _openExerciseFilterDialog,
              ),
              IconButton(
                icon: const Icon(Icons.date_range_rounded),
                onPressed: _openDayFilterDialog,
              )
            ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.amberAccent),
                    columnSpacing: 20,
                    sortColumnIndex: _currentSortColumn,
                    sortAscending: _isAscending,
                    columns: <DataColumn>[
                      DataColumn(
                          label: InkWell(
                              child: Text(
                                'Day #',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                          ),
                          onSort: handleSort,
                      ),
                      DataColumn(
                          label: Text(
                            'Exercise Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          onSort: handleSort
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
                    rows: widget.apiResponse.where((item) =>
                        selectedExercises.contains(item["exercise_name"])).toList().where(
                        (item) => selectedDays.contains(item["today_day"].toString())
                    ).toList().map(
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
            isLoading == true? Container(
              color: Colors.black.withOpacity(0.5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator(),)):Container(),
          ],
        )
      ),
    );
  }
}