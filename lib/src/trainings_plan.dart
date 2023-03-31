import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kieser/model/lib/preferences.dart';
import 'package:kieser/src/app_bar.dart';
import 'package:kieser/src/handle_results.dart';
import 'package:kieser/src/tab_content.dart';
import 'package:model/plan.dart';
import 'package:sembast/sembast.dart';

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
    with TickerProviderStateMixin {
  late Visibility _fab;
  Map<String, dynamic> preferences = {};
  List<Map<String, dynamic>> _stations = [];
  late TabController _tabController;
  List<Widget> tabContents = <Widget>[];
  bool _showFAB = false;
  String _title = '';

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

  Future<void> _getStations() async {
    Plan plan = Plan(widget.database, widget.customerID);
    _stations = await plan.getStations();
  }

  Future<Map<String, dynamic>> _getPreferences() async {
    Preferences p = Preferences(widget.database);
    preferences = await p.loadPrefs();

    return preferences;
  }

  Widget _getTabContent(
      TabController tabController, void Function() moveForward) {
    tabContents = [];

    for (Map<String, dynamic> station in _stations) {
      tabContents.add(TabContent(
          database: widget.database,
          customerID: widget.customerID,
          machineID: station['machineID'],
          moveForward: _moveForward));
    }
    return TabBarView(controller: tabController, children: tabContents);
  }

  void _saveResults() {
    if (_tabController.index == _stations.length - 1) {
      saveResults(widget.database, widget.customerID, DateTime.now(), context);
    }
  }

  /**
   * Buggy behavior from Flutter SDK (beta channel 3.9.0-0.2.pre) : Setstate jumps always
   * back to first tab. Workaround is in place
   * Setstate is required to show Floating Action Button, only when last training station has been reached.
   */
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _showFAB = (_tabController.index == _stations.length - 1);

      // if (_tabController.index == _stations.length - 1) {
      //   setState(() {
      //     _tabController.animateTo(_stations.length - 1);
      //   });
      // }
    }
  }

  void _moveForward() {
    if (preferences['autoForward'] &&
        (_tabController.index < _stations.length - 1)) {
      _tabController.animateTo(_tabController.index + 1);
    }
    return;
  }

  @override
  void initState() {
    _fab = Visibility(
        child: FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: _saveResults,
      child: const Icon(Icons.save),
    ));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return FutureBuilder<void>(
        future: Future.wait([_getPreferences(), _getStations()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _title =
                'Trainings-Plan für\n!customerName! (${widget.customerID})';
            _tabController = TabController(
                length: _stations.length, initialIndex: 0, vsync: this);
            _tabController.addListener(_handleTabSelection);
            return Scaffold(
                appBar: KieserAppBar(
                  database: widget.database,
                  customerID: widget.customerID,
                  title: _title,
                ),
                floatingActionButton:
                    _fab, // _showFAB ? _fab : Container(), TODO: Remove workaround
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
                      Expanded(
                          child: _getTabContent(_tabController, _moveForward))
                    ]));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        });
  }
}
