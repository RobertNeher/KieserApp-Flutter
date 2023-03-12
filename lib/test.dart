import 'package:kieser/settings/lib/settings.dart';
import 'package:kieser/model/lib/customer.dart';
import 'package:kieser/model/lib/machine.dart';
import 'package:kieser/model/lib/plan.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main(List<String> args) async {
  Database database = await databaseFactoryIo.openDatabase('./$DB_FILE');
  final StoreRef machinesStore = intMapStoreFactory.store("machines");
  Machine m = Machine(database);
  print(await m.getAll());
  print(await m.findByID('A 3'));

  // Finder finder = Finder(filter: Filter.equals('id', args[0]));
  // var records = await machinesStore.find(database) as Iterable;
  // Map<String, dynamic> result = {};

  // for (RecordSnapshot machine in records) {
  //   print('${machine.value["id"]}:${args[0]}');
  //   if (machine.value['id'] == args[0]) {
  //     result = machine.value as Map<String, dynamic>;
  //     print(result);
  //     break;
  //   }
  // }
  // print(result['id']);
}
