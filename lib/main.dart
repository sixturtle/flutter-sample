import 'package:flutter/material.dart';

import 'screens/loginScreen.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
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
