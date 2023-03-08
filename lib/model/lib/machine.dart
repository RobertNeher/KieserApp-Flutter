import 'package:sembast/sembast.dart';

class Machine {
  late final Database _database;
  late final StoreRef _machineStore;
  List<Map<String, dynamic>> _machines = [];

  Future<List<Map<String, dynamic>>> getAll() async {
    var records = await _machineStore.find(_database);

    if (records.isEmpty) {
      return [];
    }
    _machines = [];
    for (var record in records) {
      _machines.add(record.value as Map<String, dynamic>);
    }
    return _machines;
  }

  Machine(Database database) {
    _database = database;
    _machineStore = intMapStoreFactory.store("machines");
    getAll();
  }

  Future<Map<String, dynamic>> findByID(String machineID) async {
    List<Map<String, dynamic>> allMachines = await getAll();
    for (Map<String, dynamic> machine in allMachines) {
      if (machine['id'] == machineID) {
        return machine;
      }
    }
    return {};
  }

  Future<List<String>> getParameters(String machineID) async {
    Map<String, dynamic> machine = await findByID(machineID);
    if (machine.isNotEmpty) return (machine['parameters']).cast<String>();
    return [];
  }
}
