import 'dart:convert';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
enum MemberType { scout, adult }

class Member {
  var id;
  var customerId;
  var firstName;
  var lastName;
  var memberType;
  var joiningDate;
  var leavingDate;

  Member(
      {this.id,
      this.customerId,
      this.firstName,
      this.lastName,
      this.memberType,
      this.joiningDate,
      this.leavingDate});

  factory Member.fromJson(var id, Map<String, dynamic> json) {
    return Member(
        id: id,
        customerId: json['customerId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        memberType: json['memberType'],
        joiningDate: json['joiningDate'],
        leavingDate: json['leavingDate']);
  }

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'firstName': firstName,
        'lastName': lastName,
        'memberType': memberType,
        'joiningDate': joiningDate,
        'leavingDate': leavingDate
      };

  String toString() {
    return json.encode(this);
  }
}
