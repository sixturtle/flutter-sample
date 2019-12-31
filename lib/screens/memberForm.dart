import 'package:flutter/material.dart';

import '../services/memberService.dart';
import '../models/customer.dart';
import '../models/member.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class MemberForm extends StatefulWidget {
  final Customer customer;
  final Member member;

  const MemberForm({Key key, this.customer, this.member}) : super(key: key);

  @override
  _MemberFormState createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final memberType = TextEditingController();
  final joiningDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      firstName.text = widget.member.firstName;
      lastName.text = widget.member.lastName;
      memberType.text = widget.member.memberType;
      joiningDate.text = widget.member.joiningDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Add members for ${widget.customer.lastName}, ${widget.customer.firstName}"),
        ),
        body: customerForm);
  }

  Widget buildInput(var label, var controller) => TextFormField(
        controller: controller,
        decoration: new InputDecoration(
          hintText: label,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter value';
          }
          return null;
        },
      );

  Future<void> _createMember(BuildContext context) async {
    Member member = await MemberService()
        .findByField(fieldName: 'firstName', fieldValue: firstName.text);

    if (member == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing...')));
      await MemberService().create(Member(
          customerId: widget.customer.id,
          firstName: firstName.text,
          lastName: lastName.text,
          memberType: memberType.text,
          joiningDate: joiningDate.text));

      Navigator.pop(context);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Member already exists')));
    }
  }

  Future<void> _updateMember(BuildContext context) async {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing...')));
    await MemberService().update(
        widget.member.id,
        Member(
            customerId: widget.member.customerId,
            firstName: firstName.text,
            lastName: lastName.text,
            memberType: memberType.text,
            joiningDate: joiningDate.text));

    Navigator.pop(context);
  }

  Widget get submitButton => Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (widget.member == null) {
                  _createMember(context);
                } else {
                  _updateMember(context);
                }
              }
            },
            child: Text('Save'),
          ),
        );
      });

  Widget get cancelButton => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      );

  Widget get customerForm => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildInput("First Name", firstName),
              buildInput("Last Name", lastName),
              buildInput("memberType", memberType),
              buildInput("joiningDate", joiningDate),
              Row(children: <Widget>[
                cancelButton,
                SizedBox(width: 10),
                submitButton
              ])
            ],
          ),
        ),
      );
}
