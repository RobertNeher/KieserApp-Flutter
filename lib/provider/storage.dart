import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:sembast/sembast.dart';
// import 'package:provider/provider.dart';

class Storage with ChangeNotifier {
  late final Database _database;
  late StoreRef _tempStore;
  late StoreRef _resultStore;
  List<Map<String, dynamic>> _trainingResults = <Map<String, dynamic>>[];

  Storage(Database database) {
    _database = database;
    _tempStore = intMapStoreFactory.store(TEMP_STORE);
    _resultStore = intMapStoreFactory.store('results');
  }

  List<Map<String, dynamic>> get results {
    return _trainingResults;
  }

  void addResult(Map<String, dynamic> stationResult) {
    for (Map<String, dynamic> result in _trainingResults) {
      Map<String, dynamic> target = _trainingResults.firstWhere(
          (item) => item["machineID"] == stationResult['machineID']);
      if (target.isNotEmpty) {
        target['duration'] = stationResult['duration'];
        target['weightDone'] = stationResult['weightDone'];
        target['weightPlanned'] = stationResult['weightPlanned'];
        break;
      } else {
        _trainingResults.add(stationResult);
      }
    }
    notifyListeners();
  }
}
