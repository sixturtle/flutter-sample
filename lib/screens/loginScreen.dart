import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'customerScreen.dart';
import '../models/user.dart';
import '../services/userService.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

final FirebaseAuth _auth = FirebaseAuth.instance;

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
    //_googleSignIn.signInSilently();
  }

  Widget get loginButton => Builder(builder: (BuildContext context) {
        return Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _handleSignIn().then((user) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerScreen(currentUser: user)));
              });
            },
            child: Text("Login to continue", textAlign: TextAlign.center),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 155.0,
                child: Image.asset("images/bsa-logo.png", fit: BoxFit.contain)),
            SizedBox(height: 45.0),
            Center(child: loginButton)
          ],
        ),
      ),
    ));
  }

  Future<User> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      User dbUser = await UserService().findByUserId(googleUser.id);
      if (dbUser == null) {
        print('First time log-in, creating user...');
        dbUser = User(
            userId: googleUser.id,
            displayName: googleUser.displayName,
            email: googleUser.email,
            photoUrl: googleUser.photoUrl);
        await UserService().create(dbUser);
        print('User ${dbUser.email} created successfully');
      } else {
        print('User ${dbUser.email} already exists');
      }

      return dbUser;
    } catch (error) {
      print(error);
    }
  }
}
