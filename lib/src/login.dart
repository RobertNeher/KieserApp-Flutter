import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/drawer.dart';
import 'package:kieser/src/trainings_plan.dart';
import 'package:model/preferences.dart';
import 'package:sembast/sembast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  Map<String, dynamic> customerDetail = {};
  Map<String, dynamic> preferences = {};
  int _customerID = 0;
  late TextEditingController tec;

  Future<Map<String, dynamic>> _getPrefs() async {
    Preferences p = Preferences();
    preferences = await p.loadPrefs();
    _customerID = preferences['customerID'];
    tec = TextEditingController(text: _customerID.toString());
    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _getPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.blue, strokeWidth: 5));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: KieserAppBar(customerID: 0, title: 'Login'),
                drawer: KieserDrawer(context),
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
                            decoration:
                                const InputDecoration(labelText: "Customer ID"),
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

                                  return TrainingsPlan(customerID: _customerID);
                                }));
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
