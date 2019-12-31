import 'dart:convert';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class User {
  var documentID;
  var userId;
  var displayName;
  var email;
  var photoUrl;

  User(
      {this.documentID,
      this.userId,
      this.displayName,
      this.email,
      this.photoUrl});

  factory User.fromJson(var documentID, Map<String, dynamic> json) {
    return User(
        documentID: documentID,
        userId: json['userId'],
        displayName: json['displayName'],
        email: json['email'],
        photoUrl: json['photoUrl']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl
      };

  String toString() {
    return json.encode(this);
  }
}
