import 'package:kieser/model/lib/preferences.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:kieser/model/lib/customer.dart';
import 'package:kieser/model/lib/machine.dart';
import 'package:kieser/model/lib/plan.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main(List<String> args) async {
  Database database = await databaseFactoryIo.openDatabase(DB_FILE);
  // Map<String, dynamic> prefs = PREFERENCES_DATASET[0];
  StoreRef prefsStore = intMapStoreFactory.store("preferences");
  Preferences prefs = await Preferences(database);

  // int counter = prefs.getDefaultDuration + 1;
  // print(counter);
  print(prefs);

  // Map<String, dynamic> data = {
  //   'customerID': preferences.getCustomerID,
  //   'defaultDuration': preferences.getDefaultDuration,
  //   'autoForward': preferences.getAutoForward,
  // };
  // print(preferences.defaultDuration);
  // print(preferences.autoForward);
  // print(preferences.customerID);
  // print(data);
  // await prefsStore.update(await database, data);

  // var record = await prefsStore.find(database);

  // print(record);

  // result = await prefsStore.update(database, !preferences.autoForward,
  //     finder: finder);
  // print(preferences.defaultDuration);
  // print(preferences.autoForward);
  // print(preferences.customerID);
}
