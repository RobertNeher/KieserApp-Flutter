import 'package:kieser/model/lib/customer.dart';
import 'package:kieser/model/lib/machine.dart';
import 'package:kieser/model/lib/plan.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main(List<String> args) async {
  Database database = await databaseFactoryIo.openDatabase('assets/test.db');

  Customer c = Customer(database);
  print(c.getAll());
}
