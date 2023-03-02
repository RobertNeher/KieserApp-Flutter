// import 'package:model/customer.dart';
import 'package:model/plan.dart';
import 'package:model/machine.dart';
import 'package:sembast/sembast.dart';

class TrainingData {
  late Database _database;
  int customerID = 0;
  late List<Map<String, dynamic>> machines;
  late Plan plan;

  _getMachines(Machine machine) async {
    machines = await machine.getAll();
  }

  TrainingData(Database database, int customerID) {
    _database = database;
    Machine machine = Machine(_database);
    customerID = customerID;
    _getMachines(machine);
    plan = Plan(_database, customerID);
  }
}
