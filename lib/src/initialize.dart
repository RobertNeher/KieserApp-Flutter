import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:settings/settings.dart';

void initializeApp() async {
  final StoreRef customersStore = intMapStoreFactory.store("customers");
  final StoreRef machinesStore = intMapStoreFactory.store("machines");
  final StoreRef plansStore = intMapStoreFactory.store("plans");
  final StoreRef resultsStore = intMapStoreFactory.store("results");
  final StoreRef prefsStore = intMapStoreFactory.store("preferences");
  final StoreRef tempStore = intMapStoreFactory.store(TEMP_STORE);

  final Database database = GetIt.I.get();

  await customersStore.delete(database);
  await machinesStore.delete(database);
  await plansStore.delete(database);
  await resultsStore.delete(database);
  await tempStore.delete(database);

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

  for (Map<String, dynamic> result in RESULTS_DATASET) {
    await resultsStore.add(database, result);
  }
}

void main(List<String> args) async {
  final Database database = await databaseFactoryIo.openDatabase(DB_FILE);

  GetIt.I.registerSingleton<Database>(database);

  initializeApp();
  print('Initialization of database ($DB_FILE) done');
}
