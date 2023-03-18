import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Future<List<Map<String, dynamic>>> getTrainingResults(int customerID) async {
  final Database database;
  List<Map<String, dynamic>> results = [];

  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase('assets/results.db');
  } else {
    database = await databaseFactoryIo.openDatabase('assets/results.db');
  }
  final StoreRef resultsStore = intMapStoreFactory.store("results_store");

  var temp = await resultsStore.find(database);

  if (temp.isNotEmpty) {
    Iterable resultList = temp[0]['trainings'] as Iterable;
    for (var entry in resultList) {
      results.add(entry as Map<String, dynamic>);
    }
  }
  return results;
}

void saveResults(
    int customerID, DateTime dateTime, BuildContext context) async {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final SharedPreferences prefs = await _prefs;
  final DateFormat df = DateFormat('yyyy-MM-dd');
  final Database database;
  final List<Map<String, dynamic>> results =
      await getTrainingResults(customerID);

  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase('assets/results.db');
  } else {
    database = await databaseFactoryIo.openDatabase('assets/results.db');
  }

  final StoreRef resultsStore = intMapStoreFactory.store("results_store");
  // await resultsStore.delete(database);

  // List<Map<String, dynamic>> resultMap = await getTrainingResults(customerID);
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

void removeCustomerResults(int customerID) async {
  final Database database;

  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase('assets/results.db');
  } else {
    database = await databaseFactoryIo.openDatabase('assets/results.db');
  }

  final StoreRef resultsStore = intMapStoreFactory.store("results_store");

  Finder finder = Finder(filter: Filter.equals('customerID', customerID));
  await resultsStore.delete(database, finder: finder);
}
