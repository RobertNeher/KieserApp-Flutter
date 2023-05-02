import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:kieser/provider/storage.dart';
import 'package:kieser/src/initialize.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import 'package:settings/settings.dart';
import 'package:kieser/src/about.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await windowManager.ensureInitialized();
  // if (Platform.isWindows) {
  //   WindowManager.instance.setMinimumSize(const Size(1200, 600));
  //   WindowManager.instance.setMaximumSize(const Size(1200, 600));
  // }
  final Database database;
  final Directory directory;
  final String dbPath;

  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase(DB_FILE);
  } else /*if (Platform.isAndroid)*/ {
    directory = await getApplicationDocumentsDirectory();
    dbPath = join(directory.path, DB_FILE);
    database = await databaseFactoryIo.openDatabase(dbPath);
  }

  GetIt.I.registerSingleton<Database>(database);

  initializeApp();

  runApp(ChangeNotifierProvider<Storage>(
      create: (_) => Storage(), child: KieserApp()));
}

class KieserApp extends StatelessWidget {
  KieserApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AboutPage(title: APP_TITLE),
    );
  }
}
