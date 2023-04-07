import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:sembast/sembast.dart';
import 'package:intl/intl.dart';

class Storage with ChangeNotifier {
  late final Database _database;
  late StoreRef _tempStore;
  late StoreRef _resultStore;
  List<Map<String, dynamic>> _trainingResults = <Map<String, dynamic>>[];

  Storage() {
    _database = GetIt.I.get();
    _tempStore = intMapStoreFactory.store(TEMP_STORE);
    _resultStore = intMapStoreFactory.store('results');
  }

  List<Map<String, dynamic>> get results {
    return _trainingResults;
  }

  Future<void> addResult(Map<String, dynamic> stationResult) async {
    Finder finder =
        Finder(filter: Filter.equals('machineID', stationResult['machineID']));
    var records = await _tempStore.findFirst(_database, finder: finder);

    if (records == null) {
      await _tempStore.add(_database, stationResult);
    } else {
      Map<String, dynamic> result = {
        'machineID': stationResult['machineID'],
        'duration': stationResult['duration'],
        'weightDone': stationResult['weightDone'],
        'weightPlanned': stationResult['weightPlanned']
      };
      print(result);
      await _tempStore.record(records.key).put(_database, result);
    }
    notifyListeners();
  }
}
