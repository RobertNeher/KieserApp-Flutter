import 'package:flutter/material.dart';
import 'package:kieser/model/lib/plan.dart';
import 'package:model/machine.dart';

// import 'package:model/plan.dart';
const double ROW_HEIGHT = 35;

class ShowParameterAndValues extends StatefulWidget {
  const ShowParameterAndValues(
      {Key? key,
      required this.customerID,
      required this.machineID})
      : super(key: key);
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
    trainingsPlan = Plan(widget.customerID);
    machines = Machine();
    // _getParameters();
    // _getParameterValues();
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
            for (i = 0; i < parameters.length; i++) {
              tableRows.add(TableRow(children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
                    child: SizedBox(
                        // width: 40,
                        height: ROW_HEIGHT,
                        child: Text(parameters[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)))),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Text(parameterValues[i],
                      style: const TextStyle(
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
                      child: Text("Bewegung",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white)))),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(parameterValues[i],
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white)),
              )
            ]));
            tableRows.add(TableRow(children: [
              const TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: SizedBox(
                      height: ROW_HEIGHT,
                      child: Text("Notizen",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white)))),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Text(parameterValues[i + 1],
                    style: const TextStyle(
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
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.red),
            ));
          }
        });
  }
}
