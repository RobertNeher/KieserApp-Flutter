import 'dart:convert';
import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:settings/settings.dart';

class Result {
  int _customerID = 0;
  Database? _database;
  List<Map<String, dynamic>> _results = [];
  final StoreRef _resultsStore = intMapStoreFactory.store("results");

  Result(Database database, int customerID) {
    _database = database;
    _customerID = customerID;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Finder finder = Finder(
        filter: Filter.equals('customerID', 19711),
        sortOrders: [SortOrder('trainingDate', false)]);
    var trainings = await _resultsStore.find(_database!, finder: finder);

    _results = [];
    for (var training in trainings) {
      Map<String, dynamic> result = training.value as Map<String, dynamic>;
      _results.add(result);
    }
    return _results;
  }

  Future<Map<String, dynamic>> getLatest() async {
    Finder finder = Finder(
        filter: Filter.equals('customerID', 19711),
        sortOrders: [SortOrder('trainingDate', false)]);
    var latest = await _resultsStore.findFirst(_database!, finder: finder);

    _results = _results = [latest!.value as Map<String, dynamic>];

    return _results[0];
  }
}

void main(List<String> args) async {
  Database database = await databaseFactoryIo.openDatabase(DB_FILE);
  StoreRef resultStore = intMapStoreFactory.store('results');
}
