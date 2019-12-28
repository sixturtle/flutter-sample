import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomeScreen extends StatelessWidget {
  GoogleSignInAccount currentUser;
  
  HomeScreen({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), tooltip: 'Navigation menu', onPressed: null),
        title: Text('BSA Troop 158'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app), 
            tooltip: 'Logout', 
            onPressed: (){
              Navigator.pop(context);
            }),
        ],
      ),
      body: Center(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GoogleUserCircleAvatar(
                  identity: this.currentUser,
              ),
            Text(this.currentUser.email)
          ],
        )),
    );
  }
}