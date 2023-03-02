import 'package:flutter/material.dart';
import 'package:kieser/src/settings_page.dart';

class KieserAppBar extends StatefulWidget with PreferredSizeWidget {
  KieserAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(55);
  @override
  State<KieserAppBar> createState() => _KieserAppBarState();
}

class _KieserAppBarState extends State<KieserAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/kieser.png',
              height: 70,
              width: 90,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                  fontFamily: "Railway",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
          ]),
    );
  }
}
