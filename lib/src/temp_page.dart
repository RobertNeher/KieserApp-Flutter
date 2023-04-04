import 'package:flutter/material.dart';
import 'package:kieser/settings/lib/settings.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class TempPage extends StatefulWidget {
  TempPage({Key? key, String title = ''}) : super(key: key);
  final String title = '';

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  Database database = GetIt.I.get();
  StoreRef tempRef = intMapStoreFactory.store(TEMP_STORE);
  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    List<RecordSnapshot> records = await tempRef.find(database);

    for (RecordSnapshot record in records) {
      data.add(record.value as Map<String, dynamic>);
    }
    print(data);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: KieserAppBar(
            title: widget.title,
            customerID: 0,
          ),
        ),
        body: FutureBuilder<void>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.blue, strokeWidth: 5));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                List<DataRow> rows = [];

                const List<DataColumn> columns = [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Duration')),
                  DataColumn(label: Text('Weight Done')),
                  DataColumn(label: Text('Weight Planned'))
                ];
                return Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: DataTable(
                            columns: columns,
                            rows: rows,
                            border: TableBorder.all(color: Colors.grey))));
              } else {
                return const Center(
                    child: Text('Something went wrong!',
                        style: TextStyle(
                            // fontFamily: 'Railway',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.red)));
              }
            }));
  }
}
