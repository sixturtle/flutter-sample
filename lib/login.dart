import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

// https://github.com/flutter/plugins/blob/master/packages/google_sign_in/google_sign_in/example/lib/main.dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        print(_currentUser);
        
      });
    });
    _googleSignIn.signInSilently();

  }

  @override
  Widget build(BuildContext context) {

    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            _handleSignIn();
            if (this._currentUser != null) {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => HomeScreen(currentUser: this._currentUser)));
            }
          },
          child: Text("Login to continue", textAlign: TextAlign.center),
        ),
      );

    return Material(
      child: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ 
              SizedBox(height: 155.0, child: Image.asset("images/bsa-logo.png", fit: BoxFit.contain)),
              SizedBox(height: 45.0),
              Center(child: loginButton)
            ],
          ),
        ),
      )
    );
  }


  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  // Firebase example did not work. it failed at google sign-in
  // https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/example/lib/signin_page.dart
  

}
  