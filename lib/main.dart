import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart'; // WEB

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

  //WEB
  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase(DB_FILE);
    GetIt.I.registerSingleton<Database>(database);
  } else if (Platform.isAndroid) {
    Directory directory = await getApplicationDocumentsDirectory();
    database =
        await databaseFactoryIo.openDatabase(join(directory.path, DB_FILE));
    GetIt.I.registerSingleton<Database>(database);
  }

  runApp(const KieserApp());
}

class KieserApp extends StatelessWidget {
  const KieserApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Railway',
      ),
      home: AboutPage(title: APP_TITLE),
    );
  }
}
