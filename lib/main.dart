import 'package:flutter/material.dart';

import 'login.dart';

void main() => runApp(TreasurerApp());

class TreasurerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BSA Troop 158', // used by the OS task switcher
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginScreen(),
    );
  }
}


