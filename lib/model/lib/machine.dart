import 'package:sembast/sembast.dart';

class Machine {
  late final Database _database;
  late final StoreRef _machineStore;
  List<Map<String, dynamic>> _machines = [];

  Future<void> _findMachines() async {
    List<RecordSnapshot<Object?, Object?>> records = [];
    records = await _machineStore.find(_database);

    _machines = [];
    for (RecordSnapshot<Object?, Object?> record in records) {
      _machines.add(record.value as Map<String, dynamic>);
    }
  }

  Machine(Database database) {
    _database = database;
    _machineStore = intMapStoreFactory.store("machines");

    _findMachines();
  }

  List<Map<String, dynamic>> getAll() {
    return _machines;
  }

  Map<String, dynamic> findByID(String machineID) {
    for (Map<String, dynamic> machine in _machines) {
      if (machine['machineID'] == machineID) {
        return machine;
      }
    }
    return {};
  }

  List<String> getParameters(String machineID) {
    Map<String, dynamic> machine = findByID(machineID);

    if (machine.isNotEmpty) return machine['parameters'];
    return [];
  }
}
