import 'dart:io';

import 'package:settings/settings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:kieser/model/lib/result.dart';

void main(List<String> args) async {
  final Database database = await databaseFactoryIo.openDatabase(DB_FILE);
  String machineID = 'b 5';
  print(File('assets/images/${machineID.replaceAll(" ", "").toUpperCase()}.png')
      .existsSync());
}
