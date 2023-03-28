import 'dart:io';
import 'dart:math';

import 'package:settings/settings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:kieser/model/lib/result.dart';

void main(List<String> args) async {
  final Database database = await databaseFactoryIo.openDatabase(DB_FILE);
  final StoreRef resultsStore = intMapStoreFactory.store("results");
  final StoreRef tempResult = intMapStoreFactory.store('temp');
  List<Map<String, dynamic>> results = [];
  List<RecordSnapshot> tempResults = await tempResult.find(database);
  Map<String, dynamic> temp = {};

  for (RecordSnapshot stationResult in tempResults) {
    temp = stationResult.value as Map<String, dynamic>;
    results.add(temp);
  }
  print(results);
}
