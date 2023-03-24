import 'package:flutter/material.dart';
import 'package:kieser/model/lib/result.dart';
import 'package:intl/intl.dart';
import 'package:sembast/sembast.dart';

Future<List<Map<String, dynamic>>> getTrainingResults(
    Database database, int customerID) async {
  List<Map<String, dynamic>> results = [];

  Result _results = Result(database, customerID);

  results = await _results.getAll();

  return results;
}

void saveResults(Database database, int customerID, DateTime dateTime,
    BuildContext context) async {
  final DateFormat df = DateFormat('yyyy-MM-dd');
  final List<Map<String, dynamic>> results =
      await getTrainingResults(database, customerID);

  final StoreRef resultsStore = intMapStoreFactory.store("results");
  Map<String, dynamic> resultJson = {'customerID': customerID, 'trainings': []};

  resultJson['trainings']
      .add({'trainingDate': df.format(DateTime.now()), 'results': results});
  await resultsStore.add(database, resultJson);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content:
          Text('Ihre Trainingsresultate sind erfolgreich gespeichert worden.'),
    ),
  );
}

void removeCustomerResults(Database database, int customerID) async {
  final StoreRef resultsStore = intMapStoreFactory.store("results");
  Finder finder = Finder(filter: Filter.equals('customerID', customerID));
  await resultsStore.delete(database, finder: finder);
}
