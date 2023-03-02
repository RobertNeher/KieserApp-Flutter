import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kieser/src/get_parameters.dart';
import 'package:kieser/src/training_result.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget TabContent(Database database, int customerID,
    Map<String, dynamic> machine, VoidCallback moveForward) {
  Map<String, dynamic> defaults = {};
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getDefaults() async {
    SharedPreferences prefs = await _prefs;

    if (prefs.containsKey(machine['id'])) {
      defaults = json.decode(prefs.getString(machine['id'])!);
    }
    if (defaults['duration'] == null || defaults['duration'] == 0) {
      defaults['duration'] = prefs.getInt('DEFAULT_DURATION');
    }
  }

  print('${machine}'); // TODO: remove before release version
  return Container(
      width: 500,
      color: Colors.black,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Text(machine['title'] == '-' ? 'Zweck der Maschine' : machine['title'],
            style: const TextStyle(
                fontFamily: "Railway",
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white)),
        const Divider(
          height: 15,
          color: Colors.blue,
          thickness: 1,
        ),
        Container(
            width: 400,
            height: 275,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(7),
                      width: 175,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Muskelpartien',
                              style: TextStyle(
                                  fontFamily: "Railway",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            Text(
                                machine['affectedBodyParts'] ??
                                    'Hier kommt ein Bild der aktiven Körperpartien',
                                style: const TextStyle(
                                    fontFamily: "Railway",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.white)),
                            const Divider(
                              height: 20,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            const Text(
                              'Beschreibung',
                              style: TextStyle(
                                  fontFamily: "Railway",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            Text(
                                machine['description'] ??
                                    "Das Gerät macht das und das",
                                style: const TextStyle(
                                    fontFamily: "Railway",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.white)),
                          ])),
                  const VerticalDivider(
                    thickness: 1,
                    width: 15,
                    color: Colors.blue,
                  ),
                  Container(
                      alignment: Alignment.topRight,
                      width: 175,
                      child: showParameterAndValues(
                          database, customerID, machine)),
                ])),
        const Divider(
          height: 15,
          thickness: 1,
          color: Colors.blue,
        ),
        TrainingResultForm(machine, moveForward)
      ]));
}
