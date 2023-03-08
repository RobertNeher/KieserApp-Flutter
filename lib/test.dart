import 'package:kieser/settings/lib/settings.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:kieser/model/lib/customer.dart';
import 'package:kieser/model/lib/machine.dart';
import 'package:kieser/model/lib/plan.dart';
// import 'package:kieser/src/initialize.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main(List<String> args) async {
  Database database = await databaseFactoryIo.openDatabase('./$DB_FILE');
  final StoreRef _plansStore = intMapStoreFactory.store("plans");
  List<Map<String, dynamic>> _plans = [];

  Machine m = Machine(database);
  print(await m.getAll());
  print(await m.findByID('F 1.1'));

  Customer c = Customer(database);
  // print(await c.getAll());
  // print(await c.findByID(19712));

  Plan p = Plan(database, 19711);
  // print(await p.getAll());
  print('Params: ${await p.getStationParameters("F 1.1")}');
  print('Values: ${await p.getStationParameterValues("F 1.1")}');
}
