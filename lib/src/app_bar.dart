import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:kieser/model/lib/customer.dart';

class KieserAppBar extends StatefulWidget with PreferredSizeWidget {
  KieserAppBar({Key? key, required this.customerID, required this.title})
      : super(key: key);
  final int customerID;
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(55);
  @override
  State<KieserAppBar> createState() => _KieserAppBarState();
}

class _KieserAppBarState extends State<KieserAppBar> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _customerDetail = {};

    Future<void> _getCustomerDetail() async {
      Customer customer = Customer();
      _customerDetail = await customer.findByID(widget.customerID);
    }

    return AppBar(
      title: FutureBuilder<void>(
          future: _getCustomerDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.blue, strokeWidth: 5));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              String title = '';
              if (widget.customerID > 0) {
                title = widget.title
                    .replaceFirst('!customerName!', _customerDetail['name']);
              } else {
                title = widget.title;
              }
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/kieser.png',
                      height: 70,
                      width: 90,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontFamily: "Railway",
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
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
          }),
    );
  }
}
