import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kieser/model/lib/preferences.dart';
import 'package:kieser/model/lib/result.dart';
import 'package:kieser/provider/storage.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

class TrainingResultForm extends StatefulWidget {
  TrainingResultForm(
      {Key? key,
      required this.machine,
      required this.customerID,
      required this.moveForward})
      : super(key: key);
  final Map<String, dynamic> machine;
  final int customerID;
  final void Function() moveForward;
  final Map<String, dynamic> result = {};

  @override
  State<TrainingResultForm> createState() => _TrainingResultFormState();
}

class _TrainingResultFormState extends State<TrainingResultForm> {
  Map<String, dynamic> preferences = {};
  Map<String, dynamic> lastResult = {};
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController _tecDuration = TextEditingController();
  TextEditingController _tecWeightDone = TextEditingController();
  TextEditingController _tecWeightPlanned = TextEditingController();
  StoreRef tempResult = intMapStoreFactory.store(TEMP_STORE);
  late Timer _timer;
  late Database database;
  static const IconData dumbBellIcon =
      IconData(0xe800, fontFamily: 'KieserApp', fontPackage: null);
  static const IconData dumbBellNextIcon =
      IconData(0xe801, fontFamily: 'KieserApp', fontPackage: null);
  static const _oneSecondDuration = Duration(seconds: 1);
  int _start = 0;

  void _startTimer() {
  }

  @override
  void initState() {
    database = GetIt.I.get();
    _timer = Timer(const Duration(minutes: 0), () {});
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> getResults(int customerID) async {
    Result r = Result(customerID);
    lastResult = await r.getLatest();
  }

  Future<Map<String, dynamic>> getStationResult(String machineID) async {
    Result r = Result(widget.customerID);
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
    Result r = Result(widget.customerID);
    lastResult = await r.getLatest();
    preferences = await p.loadPrefs();

    Map<String, dynamic> defaults =
        await getStationResult(widget.machine['id']);
    if (_tecDuration.text.isEmpty) {
      _tecDuration.text = '120';
    }

    if (_tecWeightDone.text.isEmpty) {
      _tecWeightDone.text = defaults['weightDone'].toString();
    }
    if (_tecWeightPlanned.text.isEmpty) {
      _tecWeightPlanned.text = defaults['weightPlanned'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: Future.wait([getDefaults(), getResults(widget.customerID)]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.blue, strokeWidth: 5));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<Storage>(builder: (context, storage, child) {
              return Stack(alignment: AlignmentDirectional.topStart, children: [
                Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: [
                            SizedBox(
                                width: 100,
                                child: TextFormField(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.white),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9][0-9]*'))
                                  ],
                                  controller: _tecDuration,
                                  onEditingComplete: () {
                                    if (widget.result.containsKey('duration')) {
                                      widget.result.update(
                                          'duration',
                                          (value) =>
                                              int.parse(_tecDuration.text));
                                    } else {
                                      widget.result['duration'] =
                                          int.parse(_tecDuration.text);
                                    }
                                    storage.addResult({
                                      'machineID': widget.machine['machineID'],
                                      'duration': int.parse(_tecDuration.text),
                                      'weightDone':
                                          int.parse(_tecWeightDone.text),
                                      'weightPlanned':
                                          int.parse(_tecWeightPlanned.text)
                                    });
                                    print(
                                        'onEditingComplete (duration): ${widget.result}');
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.access_alarm_sharp,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Dauer',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  ),
                                )),
                            const Text(
                              'sec.',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 20),
                            StatefulBuilder(builder: (context, setLocalState) {
                              _timer = Timer.periodic(
                                _oneSecondDuration,
                                (Timer timer) {
                                  if (_start == 0) {
                                    setLocalState(() {
                                      timer.cancel();
                                    });
                                  } else {
                                    setLocalState(() {
                                      _start--;
                                    });
                                  }
                                },
                              );

                              return ElevatedButton.icon(
                                  onPressed: () {
                                    _start = int.parse(preferences[
                                        'duration']); // _tecDuration.text);
                                    _startTimer();
                                  },
                                  icon: const Icon(Icons.timelapse),
                                  label: Text(_start.toString()));
                            }),
                          ]),
                          Row(children: [
                            SizedBox(
                              width: 170,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.white),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[1-9][0-9,]*'))
                                ],
                                controller: _tecWeightDone,
                                keyboardType: TextInputType.number,
                                onEditingComplete: () {
                                  if (widget.result.containsKey('weightDone')) {
                                    widget.result.update(
                                        'weightDone',
                                        (value) =>
                                            int.parse(_tecWeightDone.text));
                                  } else {
                                    widget.result['weightDone'] =
                                        int.parse(_tecWeightDone.text);
                                  }
                                  print(
                                      'onEditingComplete (weightDone): ${widget.result}');
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    dumbBellIcon,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Aktuelles Gewicht',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'lbs.',
                              style: TextStyle(
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
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.white),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9][0-9,]*'))
                                  ],
                                  controller: _tecWeightPlanned,
                                  keyboardType: TextInputType.number,
                                  onEditingComplete: () {
                                    if (widget.result
                                        .containsKey('weightPlanned')) {
                                      widget.result.update(
                                          'weightPlanned',
                                          (value) => int.parse(
                                              _tecWeightPlanned.text));
                                    } else {
                                      widget.result['weightPlanned'] =
                                          int.parse(_tecWeightPlanned.text);
                                    }
                                    print(
                                        'onEditingComplete (weightPlanned): ${widget.result}');
                                  },
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      dumbBellNextIcon,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Geplantes Gewicht',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    widget.moveForward();
                                  },
                                )),
                            const Text(
                              'lbs.',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ])
                        ]))
              ]);
            });
          } else {
            return const Center(
                child: Text('Something went wrong!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.red)));
          }
        });
  }
}
