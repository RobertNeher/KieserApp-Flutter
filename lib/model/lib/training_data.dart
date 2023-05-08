import 'package:model/plan.dart';
import 'package:model/machine.dart';

class TrainingData {
  int customerID = 0;
  late List<Map<String, dynamic>> machines;
  late Plan plan;

  _getMachines(Machine machine) async {
    machines = await machine.getAll();
  }

  TrainingData(int customerID) {
    Machine machine = Machine();
    customerID = customerID;
    _getMachines(machine);
    plan = Plan(customerID);
  }
}
