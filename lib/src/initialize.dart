import 'package:sembast/sembast.dart';

import 'package:settings/settings.dart';

void initializeApp(Database database) async {
  final StoreRef customersStore = intMapStoreFactory.store("customers");
  final StoreRef machinesStore = intMapStoreFactory.store("machines");
  final StoreRef plansStore = intMapStoreFactory.store("plans");
  final StoreRef prefsStore = intMapStoreFactory.store("preferences");

  await customersStore.delete(database);
  await machinesStore.delete(database);
  await plansStore.delete(database);
  await prefsStore.delete(database);

  for (Map<String, dynamic> customer in CUSTOMER_DATASET) {
    await customersStore.add(database, customer);
  }

  for (Map<String, dynamic> machine in MACHINE_DATASET) {
    await machinesStore.add(database, machine);
  }

  for (Map<String, dynamic> plan in PLAN_DATASET) {
    await plansStore.add(database, plan);
  }

  for (Map<String, dynamic> pref in PREFERENCES_DATASET) {
    await prefsStore.add(database, pref);
  }
}
