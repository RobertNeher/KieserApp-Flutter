import 'package:flutter/material.dart';
import 'package:kieser/model/lib/preferences.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/login.dart';

class AboutPage extends StatefulWidget {
  AboutPage({super.key, required this.title});
  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Map<String, dynamic> _preferences = {};
  int _defaultDuration = 0;

  Future<Map<String, dynamic>> _getPrefs() async {
    Preferences p = Preferences();
    _preferences = await p.loadPrefs();
    _defaultDuration = _preferences['defaultDuration'];
    return _preferences;
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
                appBar: KieserAppBar(customerID: 0, title: 'About KieserApp'),
                body: Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(20),
                            height: 350,
                            width: 500,
                            color: Colors.white,
                            child: Text(
                              ABOUT_TEXT.replaceFirst('!defaultDuration!',
                                  _defaultDuration.toString()),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontFamily: "Roboto",
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage(title: 'Login')));
                              })
                        ])));
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
