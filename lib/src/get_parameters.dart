import 'package:flutter/material.dart';
import 'package:kieser/model/lib/plan.dart';
import 'package:kieser/model/lib/training_data.dart';
import 'package:model/machine.dart';
import 'package:sembast/sembast.dart';

// import 'package:model/plan.dart';
const double ROW_HEIGHT = 35;

class ShowParameterAndValues extends StatefulWidget {
  const ShowParameterAndValues(
      {Key? key,
      required this.database,
      required this.customerID,
      required this.machineID})
      : super(key: key);
  final Database database;
  final int customerID;
  final String machineID;

  @override
  State<ShowParameterAndValues> createState() => _ShowParameterAndValuesState();
}

class _ShowParameterAndValuesState extends State<ShowParameterAndValues> {
  int i = 0;
  late Plan trainingsPlan;
  late Machine machines;
  List<TableRow> tableRows = <TableRow>[];
  List<String> parameters = [];
  List<String> parameterValues = [];

  _getParameters() async {
    parameters = await machines.getParameters(widget.machineID);
  }

  _getParameterValues() async {
    parameterValues =
        await trainingsPlan.getStationParameterValues(widget.machineID);
  }

  @override
  void initState() {
    super.initState();
    trainingsPlan = Plan(widget.database, widget.customerID);
    machines = Machine(widget.database);
    _getParameters();
    _getParameterValues();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: Future.wait<void>([_getParameters(), _getParameterValues()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              strokeWidth: 5,
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print('${parameters.length}:${parameterValues.length}');
            for (i = 0; i < parameters.length - 1; i++) {
              tableRows.add(TableRow(children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: Container(
                        // width: 40,
                        height: ROW_HEIGHT,
                        child: Text(parameters[i],
                            style: const TextStyle(
                                fontFamily: "Railway",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)))),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text(parameterValues[i],
                      style: const TextStyle(
                          fontFamily: "Railway",
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white)),
                )
              ]));
            }
            tableRows.add(TableRow(children: [
              const TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: SizedBox(
                      height: ROW_HEIGHT,
                      child: Text("Notizen",
                          style: TextStyle(
                              fontFamily: "Railway",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white)))),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(parameterValues[i],
                    style: const TextStyle(
                        fontFamily: "Railway",
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white)),
              )
            ]));
            return Table(
              children: tableRows,
            );
          } else {
            return const Center(
                child: Text(
              'Something went wrong!',
              style: TextStyle(
                  // fontFamily: "Railway",
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.red),
            ));
          }
        });
  }
}
