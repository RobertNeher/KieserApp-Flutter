import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/handle_results.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.title, required this.customerID});
  final String title;
  final int customerID;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

Widget getResultTable(Map<String, dynamic> trainingResult) {
  for (Map<String, dynamic> result in trainingResult['results']) {
    TableRow tableRow = TableRow();
  }
  return Container(
      color: Colors.lightBlueAccent,
      width: 300,
      height: 400,
      child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(60),
            1: FixedColumnWidth(60),
            2: FixedColumnWidth(60),
            3: FixedColumnWidth(60)
          },
          border: TableBorder.all(
            color: Colors.blue,
            width: 1,
          )));
}

class _ResultsPageState extends State<ResultsPage> {
  final DateFormat _dfTab = DateFormat('dd. MMMM yyyy');
  late final TabController _tabController;
  List<Map<String, dynamic>> _results = [];
  List<Tab> _trainingTabs = [];
  List<Widget> _resultTables = [];

  @override
  void initState() {
    getTrainingResults(widget.customerID).then((value) => _results);

    for (Map<String, dynamic> training in _results) {
      String tabTitle = _dfTab.format(DateTime.parse(training['trainingDate']));
      _trainingTabs.add(Tab(
          child: Text(tabTitle,
              style: const TextStyle(
                fontFamily: "Railway",
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ))));
      _resultTables.add(getResultTable(training));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _results.length,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: KieserAppBar(title: widget.title),
            ),
            body: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TabBar(
                        tabs: _trainingTabs,
                      ),
                      const SizedBox(height: 10),
                      TabBarView(children: _resultTables),
                      const SizedBox(height: 20),
                      Divider(height: 1, thickness: 10, color: Colors.blue),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ]))));
  }
}
