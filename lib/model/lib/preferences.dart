import 'package:sembast/sembast.dart';
import 'package:settings/settings.dart';

class Preferences {
  late final Database _database;
  late StoreRef _prefDataStore;
  Map<String, dynamic> prefData = {};

  Preferences(Database database) {
    _database = database;
    _prefDataStore = intMapStoreFactory.store("preferences");
    _getPrefs();
  }

  void _getPrefs() async {
    var record = await _prefDataStore.find(_database);
    prefData = record[0].value as Map<String, dynamic>;
    print(defaultDuration);
  }

  set defaultDuration(int newDuration) {
    prefData['defaultDuration'] = newDuration;
  }

  int get defaultDuration {
    return prefData['defaultDuration'];
  }

  set customerID(int newID) {
    prefData['customerID'] = newID;
  }

  int get customerID {
    return prefData['customerID'];
  }

  set autoForward(bool value) {
    prefData['autoForward'] = value;
  }

  bool get autoForward {
    return prefData['autoForward'];
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
