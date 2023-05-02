import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kieser/model/lib/machine.dart';
import 'package:kieser/src/get_parameters.dart';
import 'package:kieser/src/training_result.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

class TabContent extends StatefulWidget {
  const TabContent(
      {Key? key,
      required this.customerID,
      required this.machineID,
      required this.moveForward})
      : super(key: key);
  final int customerID;
  final String machineID;
  final VoidCallback moveForward;

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  String _basePath = '';
  Map<String, dynamic> _machineDetail = {};

  Future<Map<String, dynamic>> _getMachineDetail() async {
    Machine machine = Machine();
    _machineDetail = await machine.findByID(widget.machineID);
    return _machineDetail;
  }

  Future<String> _getPath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    _basePath = directory.path;
    return directory.path;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        width: 500,
        color: Colors.black,
        child: FutureBuilder<void>(
            future: Future.wait([_getMachineDetail(), _getPath()]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.blue, strokeWidth: 5));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                          _machineDetail.isNotEmpty &&
                                  _machineDetail['title'] == '-'
                              ? 'Zweck der Maschine'
                              : _machineDetail['title'],
                          style: const TextStyle(
                              fontFamily: "Railway",
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white)),
                      const Divider(
                        height: 15,
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      SizedBox(
                          width: 400,
                          height: 275,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(7),
                                    width: 200,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          const Text(
                                            'Muskelpartien',
                                            style: TextStyle(
                                                fontFamily: "Railway",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          Image.network(
                                            join(_basePath, 'assets/images/',
                                                '${widget.machineID.replaceAll(" ", "").toUpperCase()}.png'),
                                            height: 100,
                                          ),
                                          const Divider(
                                            height: 20,
                                            color: Colors.blue,
                                            thickness: 1,
                                          ),
                                          const Text(
                                            'Beschreibung',
                                            style: TextStyle(
                                                fontFamily: "Railway",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                              height: 100,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                reverse: false,
                                                child: Text(
                                                    _machineDetail[
                                                            'description'] ??
                                                        "Das Gerät macht das und das",
                                                    style: const TextStyle(
                                                        fontFamily: "Railway",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                        color: Colors.white)),
                                              ))
                                        ])),
                                const VerticalDivider(
                                  thickness: 1,
                                  width: 15,
                                  color: Colors.blue,
                                ),
                                Container(
                                    alignment: Alignment.topRight,
                                    width: 175,
                                    child: ShowParameterAndValues(
                                        customerID: widget.customerID,
                                        machineID: _machineDetail['id'])),
                              ])),
                      const Divider(
                        height: 15,
                        thickness: 1,
                        color: Colors.blue,
                      ),
                      TrainingResultForm(
                          _machineDetail, widget.customerID, widget.moveForward)
                    ]);
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
