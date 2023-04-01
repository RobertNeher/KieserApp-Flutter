import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kieser/model/lib/result.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/handle_results.dart';
import 'package:sembast/sembast.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    super.key,
    required this.title,
    required this.customerID,
  });
  final String title;
  final int customerID;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

Widget _getResultTable(Map<String, dynamic> trainingResult) {
  List<DataRow> rowData = <DataRow>[];

  for (Map<String, dynamic> result in trainingResult['results']) {
    rowData.add(DataRow(cells: [
      DataCell(Text(result['machineID'])),
      DataCell(Text(result['duration'].toString())),
      DataCell(Text(result['weightDone'].toString())),
      DataCell(Text(result['weightPlanned'].toString())),
    ]));
  }
  return DataTable(
    columns: const <DataColumn>[
      DataColumn(label: Text('Gerät')),
      DataColumn(label: Text('Trainings-\ndauer')),
      DataColumn(label: Text('Gewicht\n(akt.Training)')),
      DataColumn(label: Text('Gewicht\n(geplant)'))
    ],
    rows: rowData,
    dataTextStyle: const TextStyle(
        fontFamily: "Railway",
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.black),
    headingTextStyle: const TextStyle(
        fontFamily: "Railway",
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black),
    border: TableBorder.all(
      color: Colors.grey,
      width: 0.75,
    ),
  );
}

class _ResultsPageState extends State<ResultsPage> {
  final DateFormat _dfTab = DateFormat('dd. MMMM yyyy');
  List<Map<String, dynamic>> _results = [];
  List<Tab> _trainingTabs = [];
  List<Widget> _resultTables = [];

  Future<List<Map<String, dynamic>>> getTrainingResults(
      int customerID) async {
    Result results = Result(customerID);

    _results = await results.getAll();

    return _results;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: getTrainingResults(widget.customerID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.blue, strokeWidth: 5));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _resultTables = [];

            for (Map<String, dynamic> training in _results) {
              String tabTitle =
                  _dfTab.format(DateTime.parse(training['trainingDate']));
              _trainingTabs.add(Tab(
                  child: Text(tabTitle,
                      style: const TextStyle(
                        fontFamily: "Railway",
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ))));
              _resultTables.add(_getResultTable(training));
            }

            return DefaultTabController(
                length: _results.length,
                child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(40),
                      child: KieserAppBar(
                          customerID: widget.customerID,
                          title: widget.title),
                    ),
                    body: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TabBar(
                            tabs: _trainingTabs,
                          ),
                          const SizedBox(height: 10),
                          Expanded(child: TabBarView(children: _resultTables)),
                          // const SizedBox(height: 20),
                          ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          const SizedBox(height: 20),
                        ])));
          } else {
            return const Center(
                child: Text('Something went wrong!',
                    style: TextStyle(
                        // fontFamily: 'Railway',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.red)));
          }
        });
  }
}
