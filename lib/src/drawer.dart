import 'package:flutter/material.dart';
import 'package:kieser/src/settings_page.dart';
import 'package:kieser/src/results_page.dart';
import 'package:kieser/src/handle_results.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget KieserDrawer(BuildContext context) {
  int _customerID = 0;
  void _getPref() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    if (prefs.containsKey('CUSTOMER_ID')) {
      _customerID = prefs.getInt('CUSTOMER_ID')!;
    }
  }

  _getPref();

  return Drawer(
      backgroundColor: Colors.lightBlue[50],
      width: 250,
      elevation: 20,
      child: ListView(children: <Widget>[
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Einstellungen'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingsPage(title: "Einstellungen"),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.collections_outlined),
          title: const Text('Letzte Ergebnisse'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(
                      customerID: _customerID, title: "Letzte Ergebnisse"),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.remove),
          title: const Text('Löschen aller Daten'),
          onTap: () {
            ConfirmDeletionDialog(context, _customerID);
          },
        ),
      ]));
}

void ConfirmDeletionDialog(BuildContext context, int customerID) {
  Widget okButton = TextButton(
    child: const Text("Ja"),
    onPressed: () {
      const SnackBar snackBar =
          SnackBar(content: Text('Alle Daten sind gelöscht!'));

      removeCustomerResults(customerID);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("Abbruch"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text('Löschen aller Daten'),
    content:
        const Text("Möchten Sie alle bisherigen Trainingsergebnisse löschen?"),
    actions: [
      okButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
