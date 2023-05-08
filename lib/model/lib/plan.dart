import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:model/machine.dart';

class Plan {
  int _customerID = 0;
  Database? _database;
  final List<Map<String, dynamic>> _plans = [];
  final StoreRef _plansStore = intMapStoreFactory.store("plans");

  Plan(int customerID) {
    _database = GetIt.I.get();
    _customerID = customerID;
    getAll().then((value) => _plans);
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
    Machine machines = Machine();
    List<Map<String, dynamic>> allMachines = await machines.getAll();

    for (Map<String, dynamic> machine in allMachines) {
      if (machine['id'] == stationID) {
        return machines.getParameters(stationID);
      }
    }
    return [];
  }

  Future<List<String>> getStationParameterValues(String stationID) async {
    List<String> paramValues = <String>[];
    List<String> parameterValues = <String>[];
    Map<String, dynamic> latestPlan = await getLatest();

    for (Map<String, dynamic> station in latestPlan['stations']) {
      if (station['machineID'] == stationID) {
        paramValues = station['parameterValues'].cast<String>();
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
    var record = await _plansStore.find(_database!, finder: finder);

    if (record.isEmpty) {
      return {};
    }
    return record[0].value as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    var records = await _plansStore.find(_database!);

    for (var item in records) {
      _plans.add(item.value as Map<String, dynamic>);
    }
    return _plans;
  }

  @override
  String toString() {
    return ('Instance of "Plan" for customer $_customerID:\n$_plans\n------');
  }
}

void main(List<String> args) async {
  Plan p = Plan(19711);
  print(await p.getLatest());
}
