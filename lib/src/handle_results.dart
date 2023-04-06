import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kieser/model/lib/result.dart';
import 'package:intl/intl.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:sembast/sembast.dart';

Future<List<Map<String, dynamic>>> getTrainingResults(
    Database database, int customerID) async {
  List<Map<String, dynamic>> results = [];

  Result _results = Result(customerID);

  results = await _results.getAll();

  return results;
}

void saveResults(
    int customerID, DateTime dateTime, BuildContext context) async {
  final Database database = GetIt.I.get();
  final DateFormat df = DateFormat('yyyy-MM-dd');

  final StoreRef resultsStore = intMapStoreFactory.store("results");
  final StoreRef tempResult = intMapStoreFactory.store(TEMP_STORE);
  Map<String, dynamic> temp = {};
  List<Map<String, dynamic>> results = [];

  List<RecordSnapshot> tempResults = await tempResult.find(database);

  for (RecordSnapshot stationResult in tempResults) {
    temp = stationResult.value as Map<String, dynamic>;
    if (!results.asMap().containsValue(temp['machineID'])) {
      results.add(temp);
    }
  }
  print('Saving results: $results');
  await resultsStore.add(database, {
    'customerID': customerID,
    'trainingDate': df.format(DateTime.now()),
    'results': results
  });

  tempResult.delete(database);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content:
          Text('Ihre Trainingsresultate sind erfolgreich gespeichert worden.'),
    ),
  );
}

void removeCustomerResults(int customerID) async {
  final Database database = GetIt.I.get();
  final StoreRef resultsStore = intMapStoreFactory.store("results");
  Finder finder = Finder(filter: Filter.equals('customerID', customerID));
  await resultsStore.delete(database, finder: finder);
}
