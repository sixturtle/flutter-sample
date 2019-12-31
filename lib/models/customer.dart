import 'dart:convert';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class Customer {
  var id;
  var firstName;
  var lastName;
  var email;
  var openingBalance = 0.0;
  var closingBalance = 0.0;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.openingBalance,
      this.closingBalance});

  factory Customer.fromJson(var id, Map<String, dynamic> json) {
    return Customer(
            id: id,
            firstName: json['firstName'],
            lastName: json['lastName'],
            email: json['email'],
            openingBalance: json['openingBalance'] ?? 0.0,
            closingBalance: json['closingBalance']) ??
        0.0;
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'openingBalance': openingBalance,
        'closingBalance': closingBalance
      };

  String toString() {
    return json.encode(this);
  }
}
