import 'package:sembast/sembast.dart';

class Customer {
  late final Database _database;
  late final StoreRef _customerStore;
  List<Map<String, dynamic>> customers = [];

  Future<List<Map<String, dynamic>>> _findCustomers() async {
    List<Map<String, dynamic>> customerList = [];
    List<RecordSnapshot<Object?, Object?>> records = [];
    records = await _customerStore.find(_database);

    for (RecordSnapshot<Object?, Object?> record in records) {
      customerList.add(record.value as Map<String, dynamic>);
    }
    return customerList;
  }

  Customer(Database database) {
    _database = database;
    _customerStore = intMapStoreFactory.store("customers");

    _findCustomers().then((value) {
      customers = value;
    });
  }

  List<Map<String, dynamic>> getAll() {
    return customers;
  }

  Map<String, dynamic> findByID(int customerID) {
    for (Map<String, dynamic> customer in customers) {
      if (customer['customerID'] == customerID) {
        return customer;
      }
    }
    return {};
  }
}
