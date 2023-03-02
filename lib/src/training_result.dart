import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget TrainingResultForm(
    Map<String, dynamic> machine, void Function() moveForward) {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController _tecDuration = TextEditingController();
  TextEditingController _tecWeightDone = TextEditingController();
  TextEditingController _tecWeightPlanned = TextEditingController();

  getDefaults() async {
    SharedPreferences prefs = await _prefs;
    int defaultDuration = prefs.getInt('DEFAULT_DURATION')!;

    if (prefs.containsKey(machine['id'])) {
      Map<String, dynamic> defaults =
          json.decode(prefs.getString(machine['id'])!);

      if (_tecDuration.text.isEmpty) {
        _tecDuration.text =
            (defaults['duration'] == null || defaults['duration'] == 0)
                ? defaultDuration.toString()
                : defaults['duration'].toString();
      }
      if (_tecWeightDone.text.isEmpty) {
        _tecWeightDone.text = defaults['weightDone'].toString();
      }
      if (_tecWeightPlanned.text.isEmpty) {
        _tecWeightPlanned.text = defaults['weightPlanned'].toString();
      }
    }
  }

  saveResults() async {
    SharedPreferences prefs = await _prefs;
    Map<String, dynamic> result = {
      if (_tecDuration.text.isNotEmpty)
        'duration':
            _tecDuration.text.isNotEmpty ? int.parse(_tecDuration.text) : 0,
      'weightDone':
          _tecWeightDone.text.isNotEmpty ? int.parse(_tecWeightDone.text) : 0,
      'weightPlanned': _tecWeightPlanned.text.isNotEmpty
          ? int.parse(_tecWeightPlanned.text)
          : 0
    };
    prefs.setString(machine['id'], json.encode(result));
  }

  const IconData dumbBellIcon =
      IconData(0xe800, fontFamily: 'KieserApp', fontPackage: null);
  const IconData dumbBellNextIcon =
      IconData(0xe801, fontFamily: 'KieserApp', fontPackage: null);

  getDefaults();

  return Form(
      key: formKey,
      onChanged: () {
        saveResults();
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              SizedBox(
                  width: 100,
                  child: TextFormField(
                    style: const TextStyle(
                        fontFamily: "Railway",
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                    ],
                    controller: _tecDuration,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.access_alarm_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Dauer',
                        style: TextStyle(
                            fontFamily: "Railway",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  )),
              const Text(
                'sec.',
                style: TextStyle(
                    fontFamily: "Railway",
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ]),
            Row(children: [
              SizedBox(
                  width: 170,
                  child: TextFormField(
                      style: const TextStyle(
                          fontFamily: "Railway",
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.white),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[1-9][0-9,]*'))
                      ],
                      controller: _tecWeightDone,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: Icon(
                          dumbBellIcon,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Aktuelles Gewicht',
                          style: TextStyle(
                              fontFamily: "Railway",
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        _tecWeightPlanned.text = value.toString();
                      })),
              const Text(
                'lbs.',
                style: TextStyle(
                    fontFamily: "Railway",
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.white),
              ),
              const SizedBox(width: 10),
              Container(
                height: 30,
                width: 1,
                color: Colors.blue,
              ),
              const SizedBox(width: 10),
              SizedBox(
                  width: 170,
                  child: TextFormField(
                    style: const TextStyle(
                        fontFamily: "Railway",
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[1-9][0-9,]*'))
                    ],
                    controller: _tecWeightPlanned,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(
                        dumbBellNextIcon,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Geplantes Gewicht',
                        style: TextStyle(
                            fontFamily: "Railway",
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      moveForward();
                    },
                  )),
              const Text(
                'lbs.',
                style: TextStyle(
                    fontFamily: "Railway",
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ]),
          ]));
}
