import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:kieser/src/initialize.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;

  if (kIsWeb) {
    database = await databaseFactoryWeb.openDatabase(DB_FILE);
  } else {
    database = await databaseFactoryIo.openDatabase(DB_FILE);
  }

  // TODO: Remove in production code
  await prefs.setInt('DEFAULT_DURATION', 120);
  await prefs.setInt('CUSTOMER_ID', 19711);
  await prefs.setBool('AUTOFORWARD', true);
  await prefs.setString('B 1',
      json.encode({'duration': 120, 'weightDone': 112, 'weightPlanned': 112}));
  await prefs.setString('B 7',
      json.encode({'duration': 120, 'weightDone': 110, 'weightPlanned': 112}));
  await prefs.setString('F 2.1',
      json.encode({'duration': 120, 'weightDone': 88, 'weightPlanned': 88}));
  await prefs.setString('F 3.1',
      json.encode({'duration': 120, 'weightDone': 88, 'weightPlanned': 90}));
  await prefs.setString('C 1',
      json.encode({'duration': 120, 'weightDone': 88, 'weightPlanned': 88}));
  await prefs.setString('C 3',
      json.encode({'duration': 120, 'weightDone': 180, 'weightPlanned': 182}));
  await prefs.setString('C 7',
      json.encode({'duration': 120, 'weightDone': 92, 'weightPlanned': 92}));
  await prefs.setString('D 5',
      json.encode({'duration': 120, 'weightDone': 70, 'weightPlanned': 72}));
  await prefs.setString('D 6',
      json.encode({'duration': 120, 'weightDone': 92, 'weightPlanned': 92}));
  await prefs.setString('H 1',
      json.encode({'duration': 120, 'weightDone': 62, 'weightPlanned': 64}));

  initializeApp(database);

  runApp(KieserApp(database: database));
}

class KieserApp extends StatelessWidget {
  KieserApp({super.key, required Database this.database});
  Database database;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AboutPage(title: APP_TITLE, database: database),
    );
  }
}
