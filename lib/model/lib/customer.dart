import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class Customer {
  late final Database _database;
  late final StoreRef _customerStore;
  List<Map<String, dynamic>> _customers = [];

  Future<List<Map<String, dynamic>>> _findCustomers() async {
    List<Map<String, dynamic>> customerList = [];
    List<RecordSnapshot<Object?, Object?>> records = [];
    records = await _customerStore.find(_database);

    for (RecordSnapshot<Object?, Object?> record in records) {
      customerList.add(record.value as Map<String, dynamic>);
    }
    return customerList;
  }

  Customer() {
    _database = GetIt.I.get();
    _customerStore = intMapStoreFactory.store("customers");

    _findCustomers().then((value) {
      _customers = value;
    });
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    var records = await _customerStore.find(_database);

    _customers = [];
    for (var item in records) {
      _customers.add(item.value as Map<String, dynamic>);
    }
    return _customers;
  }

  Future<Map<String, dynamic>> findByID(int customerID) async {
    for (Map<String, dynamic> customer in await getAll()) {
      if (customer['customerID'] == customerID) {
        return customer;
      }
    }
    return {};
  }
}
