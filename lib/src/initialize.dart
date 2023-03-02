import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';

import 'package:settings/settings.dart';

void initializeApp(Database database) async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  final StoreRef customersStore = intMapStoreFactory.store("customers");
  final StoreRef machinesStore = intMapStoreFactory.store("machines");
  final StoreRef plansStore = intMapStoreFactory.store("plans");

  await customersStore.delete(database);
  await machinesStore.delete(database);
  await plansStore.delete(database);

  for (Map<String, dynamic> customer in CUSTOMER_DATASET) {
    await customersStore.add(database, customer);
  }

  for (Map<String, dynamic> machine in MACHINE_DATASET) {
    await machinesStore.add(database, machine);
  }

  for (Map<String, dynamic> plan in PLAN_DATASET) {
    await plansStore.add(database, plan);
  }
  // TODO: Remove?
  if (!prefs.containsKey('CUSTOMER_ID')) {
    await prefs.setInt('CUSTOMER_ID', 19711);
  }
  if (!prefs.containsKey('DEFAULT_DURATION')) {
    await prefs.setInt('DEFAULT_DURATION', 120);
  }
  if (!prefs.containsKey('AUTO_FORWARD')) {
    await prefs.setBool('AUTO_FORWARD', false);
  }
}
