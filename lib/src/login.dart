import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/drawer.dart';
import 'package:kieser/src/trainings_plan.dart';
import 'package:model/preferences.dart';
import 'package:sembast/sembast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title, required this.database});
  final Database database;
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map<String, dynamic> customerDetail = {};
  late Preferences preferences;
  int _customerID = 0;
  late TextEditingController tec;

  @override
  void initState() {
    preferences = Preferences(widget.database);
    _customerID = preferences.findByID('customerID');
    tec = TextEditingController(text: _customerID.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: KieserAppBar(
            database: widget.database, customerID: 0, title: 'Login'),
        drawer: KieserDrawer(context, widget.database),
        body: Container(
            width: 500,
            height: 400,
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  TextFormField(
                    key: _formKey,
                    controller: tec,
                    maxLines: 1,
                    style: const TextStyle(
                        fontFamily: "Railway",
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black),
                    decoration: const InputDecoration(labelText: "Customer ID"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (number) {
                      _customerID = int.tryParse(number)!;
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          if (tec.text.isNotEmpty) {
                            _customerID = int.parse(tec.text);
                          }

                          return TrainingsPlan(
                              database: widget.database,
                              customerID: _customerID);
                        }));
                      }),
                ]))));
  }
}
