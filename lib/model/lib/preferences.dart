import 'package:sembast/sembast.dart';

class Preferences {
  late final Database _database;
  late StoreRef _prefDataStore;
  Map<String, dynamic> prefData = {};

  Preferences(Database database) {
    _database = database;
    _prefDataStore = intMapStoreFactory.store("preferences");
  }

  Future<Map<String, dynamic>> loadPrefs() async {
    var record = await _prefDataStore.find(_database);
    prefData = record[0].value as Map<String, dynamic>;
    return prefData;
  }

  Future<int> savePrefs(Map<String, dynamic> data) async {
    var record = await _prefDataStore.find(_database);

    return await _prefDataStore.update(_database, data);
  }

  int get defaultDuration {
    return prefData['defaultDuration'];
  }

  int get customerID {
    return prefData['customerID'];
  }

  bool get autoForward {
    return prefData['autoForward'];
  }

  Map<String, dynamic> setValues(
      {int? customerID, int? defaultDuration, bool? autoForward}) {
    prefData = {};

    if (customerID != null) {
      prefData.addAll({'customerID': customerID});
    }
    if (defaultDuration != null) {
      prefData.addAll({'defaultDuration': defaultDuration});
    }
    if (autoForward != null) {
      prefData.addAll({'autoForward': autoForward});
    }

    return prefData;
  }

  findByID(String prefID) {
    Map<String, dynamic> prefs = prefData;
    for (var pref in prefs.entries) {
      if (pref.key == prefID) {
        return pref.value;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'customerID: $customerID\ndefaultDuration: $defaultDuration\nautoForward: $autoForward';
  }
}
