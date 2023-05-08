import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class Result {
  int _customerID = 0;
  Database? _database;
  List<Map<String, dynamic>> _results = [];
  final StoreRef _resultsStore = intMapStoreFactory.store("results");

  Result(int customerID) {
    _database = GetIt.I.get();
    _customerID = customerID;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Finder finder = Finder(
        filter: Filter.equals('customerID', _customerID),
        sortOrders: [SortOrder('trainingDate', false)]);
    var trainings = await _resultsStore.find(_database!, finder: finder);

    _results = [];
    for (var training in trainings) {
      Map<String, dynamic> result = training.value as Map<String, dynamic>;
      _results.add(result);
    }
    return _results;
  }

  Future<Map<String, dynamic>> getLatest() async {
    Finder finder = Finder(
        filter: Filter.equals('customerID', _customerID),
        sortOrders: [SortOrder('trainingDate', false)]);
    RecordSnapshot? latest =
        await _resultsStore.findFirst(_database!, finder: finder);

    _results = [latest!.value as Map<String, dynamic>];

    return _results[0];
  }
}

void main(List<String> args) async {
  List<Map<String, dynamic>> machines = [];
  Result r = Result(19711);
  Map<String, dynamic> latestResult = await r.getLatest();
  // print(latestResult['results']);

  for (Map<String, dynamic> result in latestResult['results']) {
    machines.add(result);
  }
  print(machines);
}
