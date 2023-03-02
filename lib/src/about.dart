import 'package:flutter/material.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/login.dart';
import 'package:sembast/sembast.dart';

class AboutPage extends StatefulWidget {
  AboutPage({super.key, required this.title, required this.database});
  final Database database;
  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: KieserAppBar(title: widget.title),
        body: Container(
            alignment: Alignment.topCenter,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: 500,
                    color: Colors.white,
                    child: const Text(
                      ABOUT_TEXT,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Roboto",
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // const Spacer(),
                  ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                    title: 'Login',
                                    database: widget.database)));
                      })
                ])));
  }
}
