import 'package:sembast/sembast.dart';
import 'package:model/machine.dart';

class Plan {
  int _customerID = 0;
  Database? _database;
  final StoreRef _plansStore = intMapStoreFactory.store("plans");

  Plan(Database database, int customerID) {
    _database = database;
    _customerID = customerID;
  }

  Future<List<Map<String, dynamic>>> getStations() async {
    Map<String, dynamic> latest = await getLatest();
    List<Map<String, dynamic>> stations = [];

    for (Map<String, dynamic> station in latest['stations']) {
      stations.add(station);
    }
    return stations;
  }

  Future<List<String>> getStationParameters(String stationID) async {
    Machine machines = Machine(_database!);
    return machines.getParameters(stationID);
  }

  Future<List<dynamic>> getStationParameterValues(String stationID) async {
    List<dynamic> paramValues = [];
    List<dynamic> parameterValues = [];
    Map<String, dynamic> latestPlan = await getLatest();

    for (Map<String, dynamic> station in latestPlan['stations']) {
      if (station['machineID'] == stationID) {
        paramValues = station['parameterValues'];
        parameterValues.addAll(paramValues);
        parameterValues.add(station['movement']);
        parameterValues.add(station['comments']);
        return parameterValues;
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> getLatest() async {
    Finder finder = Finder(
        filter: Filter.equals('customerID', _customerID),
        sortOrders: [SortOrder('validFrom', false)]);
    var record = await _plansStore.findFirst(_database!, finder: finder);
    return record!.value as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    List<Map<String, dynamic>> result = [];
    var records = await _plansStore.find(_database!);
    for (var item in records) {
      result.add(item.value as Map<String, dynamic>);
    }
    return result;
  }
}
