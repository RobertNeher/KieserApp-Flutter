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
  late final Preferences preferences;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _customerID = 0;
  int _defaultDuration = 0;
  bool _autoForward = false;

  TextEditingController _tec_customerID = TextEditingController();
  TextEditingController _tec_defaultDuration = TextEditingController();
  TextEditingController _tec_autoForward = TextEditingController();

  @override
  void initState() {
    super.initState();
    preferences = Preferences(widget.database);
    _getPrefs();
  }

  void _setPrefs() async {
    StoreRef prefsStore = intMapStoreFactory.store("preferences");
    Map<String, dynamic> prefData = {};

    _tec_customerID.text = preferences.customerID.toString();
    _tec_defaultDuration.text = preferences.defaultDuration.toString();
    _tec_autoForward.text = preferences.autoForward.toString();

    prefData = {
      'customerID': int.parse(_tec_customerID.text),
      'defaultDuration': int.parse(_tec_defaultDuration.text),
      'autoForward': _tec_autoForward.text.isNotEmpty
    };
    print(prefData);
    await prefsStore.update(widget.database, prefData);
  }

  void _getPrefs() {
    // Preferences preferences = Preferences(widget.database);
    _customerID = preferences.customerID;
    _defaultDuration = preferences.defaultDuration;
    _autoForward = preferences.autoForward;

    _tec_customerID.text = _customerID.toString();
    _tec_defaultDuration.text = _defaultDuration.toString();
    _tec_autoForward.text = _autoForward.toString();
  }

  @override
  Widget build(BuildContext context) {
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
                        decoration:
                            const InputDecoration(labelText: "Customer ID"),
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
                        decoration:
                            const InputDecoration(labelText: "Übungsdauer"),
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
                            controlAffinity: ListTileControlAffinity.leading,
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
                            _setPrefs();
                            Navigator.pop(context);
                          }),
                    ]))));
  }
}
