import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
import 'package:kieser/model/lib/preferences.dart';
import 'package:kieser/model/lib/result.dart';
import 'package:kieser/provider/storage.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

Widget TrainingResultForm(
    Map<String, dynamic> machine, int customerID, void Function() moveForward) {
  Map<String, dynamic> preferences = {};
  Map<String, dynamic> lastResult = {};
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController _tecDuration = TextEditingController();
  TextEditingController _tecWeightDone = TextEditingController();
  TextEditingController _tecWeightPlanned = TextEditingController();
  StoreRef tempResult = intMapStoreFactory.store(TEMP_STORE);

  Future<void> getResults(int customerID) async {
    Result r = Result(customerID);
    lastResult = await r.getLatest();
  }

  Future<Map<String, dynamic>> getStationResult(String machineID) async {
    Result r = Result(customerID);
    Map<String, dynamic> latestResult = await r.getLatest();

    for (Map<String, dynamic> station in latestResult['results']) {
      if (station['machineID'] == machineID) {
        return station;
      }
    }
    return {};
  }

  Future<void> getDefaults() async {
    Preferences p = Preferences();
    Result r = Result(customerID);
    lastResult = await r.getLatest();
    preferences = await p.loadPrefs();

    int defaultDuration = preferences['defaultDuration'];
    Map<String, dynamic> defaults = await getStationResult(machine['id']);
    if (_tecDuration.text.isEmpty) {
      _tecDuration.text = '120';
      //       (defaults['duration'] == null || defaults['duration'] == 0)
      //           ? defaultDuration.toString()
      //           : defaults['duration'].toString();
    }

    if (_tecWeightDone.text.isEmpty) {
      _tecWeightDone.text = defaults['weightDone'].toString();
    }
    if (_tecWeightPlanned.text.isEmpty) {
      _tecWeightPlanned.text = defaults['weightPlanned'].toString();
    }
  }

  const IconData dumbBellIcon =
      IconData(0xe800, fontFamily: 'KieserApp', fontPackage: null);
  const IconData dumbBellNextIcon =
      IconData(0xe801, fontFamily: 'KieserApp', fontPackage: null);

  return FutureBuilder<void>(
      future: Future.wait([getDefaults(), getResults(customerID)]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.blue, strokeWidth: 5));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<Storage>(builder: (context, storage, child) {
            return Form(
              key: formKey,
              onChanged: () {
                  storage.addResult({
                    'machineID': machine['id'],
                    'duration': _tecDuration.text.isNotEmpty
                        ? int.parse(_tecDuration.text)
                        : 0,
                    'weightDone': _tecWeightDone.text.isNotEmpty
                        ? int.parse(_tecWeightDone.text)
                        : 0,
                    'weightPlanned': _tecWeightPlanned.text.isNotEmpty
                        ? int.parse(_tecWeightPlanned.text)
                        : 0
                  });
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[1-9][0-9]*'))
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
                                    fontWeight: FontWeight.normal,
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
                    ])
                    ]));
          });
        } else {
          return const Center(
              child: Text('Something went wrong!',
                  style: TextStyle(
                      // fontFamily: 'Railway',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.red)));
        }
      });
}
