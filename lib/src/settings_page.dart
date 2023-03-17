import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kieser/model/lib/preferences.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:sembast/sembast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title, required this.database});
  final Database database;
  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> preferences;
  int _customerID = 0;
  int _defaultDuration = 0;
  bool _autoForward = false;

  TextEditingController _tec_customerID = TextEditingController();
  TextEditingController _tec_defaultDuration = TextEditingController();
  TextEditingController _tec_autoForward = TextEditingController();

  Future<Map<String, dynamic>> _loadPrefs() async {
    Preferences p = Preferences(widget.database);
    preferences = await p.loadPrefs();
    _tec_customerID.text = preferences['customerID'].toString();
    _tec_defaultDuration.text = preferences['defaultDuration'].toString();
    _tec_autoForward.text = preferences['autoForward'].toString();

    return preferences;
  }

  Future<int> _savePrefs() async {
    Map<String, dynamic> values = {
      'customerID': int.parse(_tec_customerID.text),
      'defaultDuration': int.parse(_tec_defaultDuration.text),
      'autoForward': _tec_autoForward.text.isEmpty
    };
    StoreRef prefDataStore = intMapStoreFactory.store("preferences");
    var record = await prefDataStore.find(widget.database);
    return await prefDataStore.update(widget.database, values);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _loadPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.blue, strokeWidth: 5));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: KieserAppBar(
                    title: widget.title,
                    database: widget.database,
                    customerID: 0,
                  ),
                ),
                body: Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                controller: _tec_customerID,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontFamily: "Railway",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                                decoration: const InputDecoration(
                                    labelText: "Customer ID"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _customerID = int.parse((value));
                                    // _setPrefs();
                                  }
                                },
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _defaultDuration = int.parse(value);
                                    // _setPrefs();
                                  }
                                },
                                controller: _tec_defaultDuration,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontFamily: "Railway",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                                decoration: const InputDecoration(
                                    labelText: "Übungsdauer"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              // const Spacer(),
                              FormField(
                                builder: (FormFieldState<dynamic> field) {
                                  return CheckboxListTile(
                                    value: _autoForward,
                                    onChanged: (val) {
                                      if (_autoForward == false) {
                                        setState(() {
                                          _autoForward = true;
                                        });
                                      } else if (_autoForward == true) {
                                        setState(() {
                                          _autoForward = false;
                                        });
                                      }
                                    },
                                    title: const Text(
                                      'Automatisches Weiterspringen',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: Colors.blue,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    _savePrefs();
                                    Navigator.pop(context);
                                  }),
                            ]))));
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
}
