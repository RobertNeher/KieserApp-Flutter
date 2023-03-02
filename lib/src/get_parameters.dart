import 'package:flutter/material.dart';
import 'package:kieser/model/lib/plan.dart';
import 'package:kieser/model/lib/training_data.dart';
import 'package:model/machine.dart';
import 'package:sembast/sembast.dart';

// import 'package:model/plan.dart';
const double ROW_HEIGHT = 35;

Widget showParameterAndValues(
    Database database, int customerID, Map<String, dynamic> machine) {
  int i = 0;
  Plan trainingsPlan = Plan(database, customerID);
  Machine machines = Machine(database);
  List<TableRow> tableRows = <TableRow>[];
  late List<String> parameterNames;
  late List parameterValues;

  _getParameters() async {
    parameterNames = await machines.getParameters(machine['id']);
  }

  _getParameterValues() async {
    parameterValues =
        await trainingsPlan.getStationParameterValues(machine['id']);
  }

  _getParameters();
  _getParameterValues();

  for (i = 0; i < parameterNames.length - 1; i++) {
    tableRows.add(TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
              // width: 40,
              height: ROW_HEIGHT,
              child: Text(parameterNames[i],
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
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
            height: ROW_HEIGHT,
            child: const Text("Notizen",
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
}
