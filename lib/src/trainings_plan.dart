// import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:kieser/model/lib/training_data.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/handle_results.dart';
import 'package:kieser/src/tab_content.dart';
import 'package:model/plan.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingsPlan extends StatefulWidget {
  const TrainingsPlan({
    Key? key,
    required this.database,
    required this.customerID,
  }) : super(key: key);
  final Database database;
  final int customerID;

  @override
  State<TrainingsPlan> createState() => TrainingsPlanState();
}

class TrainingsPlanState extends State<TrainingsPlan>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<TrainingsPlan> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static late Visibility _fab;
  static bool _autoForward = false;
  // late TrainingData _trainingData;
  List<Map<String, dynamic>> _stations = [];
  late TabController _tabController;
  late Map<String, dynamic> _machine;
  List<Widget> tabContents = <Widget>[];
  Map<String, dynamic> _customerDetail = {};
  bool _showFAB = false;
  String _name = '';

  List<Tab> _getTabBar() {
    List<Tab> tabList = <Tab>[];

    for (Map<String, dynamic> machine in _stations) {
      Tab tab = Tab(
        child: Text(
          machine['machineID'],
        ),
      );
      tabList.add(tab);
    }
    return tabList;
  }

  Future<void> _getCustomerDetail() async {
    // Future<Map<String, dynamic>> _getCustomerDetail() async {
    final StoreRef customersStore = intMapStoreFactory.store("customers");
    final Finder finder =
        Finder(filter: Filter.equals('customerID', widget.customerID));
    var record = await customersStore.find(widget.database, finder: finder);
    _customerDetail = await record[0].value as Map<String, dynamic>;
  }

  Future<void> _getStations() async {
    Plan plan = Plan(widget.database, widget.customerID);
    _stations = await plan.getStations();
  }

  Future<void> _getAutoForward() async {
    SharedPreferences prefs = await _prefs;

    _autoForward = (prefs.containsKey('AUTOFORWARD'))
        ? prefs.getBool('AUTOFORWARD')!
        : false;
  }

  Widget _getTabContent(
      TabController tabController, void Function() moveForward) {
    tabContents = [];

    for (Map<String, dynamic> station in _stations) {
      tabContents.add(TabContent(
          widget.database, widget.customerID, _machine, _moveForward));
    }
    return TabBarView(controller: tabController, children: tabContents);
  }

  void _saveResults() {
    saveResults(widget.customerID, DateTime.now(), context);
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.indexIsChanging) {
        _showFAB = (_tabController.index == _stations.length - 1);
      }
    });
  }

  _moveForward() {
    if (_autoForward && (_tabController.index < _stations.length - 1)) {
      _tabController.index += 1;
    }
    return;
  }

  @override
  void initState() {
    _getStations().whenComplete(() {
      print('Plan2: $_stations');
    });
    _getAutoForward().whenComplete(() {
      print('Plan2: $_autoForward');
    });
    _getCustomerDetail().whenComplete(() {
      print('Plan2: $_customerDetail');
    });

    _fab = Visibility(
        child: FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: _saveResults,
      child: const Icon(Icons.save),
    ));
    // _trainingData = TrainingData(widget.database, widget.customerID);
    _tabController =
        TabController(length: _stations.length, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KieserAppBar(
          title:
              'Trainings-Plan für\n${_customerDetail["name"]} (${widget.customerID})'),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              labelPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              tabs: _getTabBar(),
              padding: const EdgeInsets.all(0),
              isScrollable: true,
              dividerColor: Colors.amber,
              indicatorColor: Colors.black,
              labelColor: Colors.white,
              unselectedLabelStyle: const TextStyle(
                  fontFamily: "Railway",
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                  color: Colors.grey),
              labelStyle: const TextStyle(
                  backgroundColor: Colors.black,
                  fontFamily: "Railway",
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
            ),
            Expanded(child: _getTabContent(_tabController, _moveForward))
          ]),
      floatingActionButton: _showFAB ? _fab : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
