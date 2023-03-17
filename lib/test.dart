import 'package:settings/settings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:kieser/model/lib/result.dart';

void main(List<String> args) async {
  final Database database = await databaseFactoryIo.openDatabase(DB_FILE);
  Result r = await Result(database, 19711);
  print(r);
  print(await r.getLatest());
}
