import 'package:flutter/material.dart';

import '../services/customerService.dart';
import '../models/customer.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Customer"),
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

  Future<void> _createCustomer(BuildContext context) async {
    Customer customer = await CustomerService()
        .findByField(fieldName: 'email', fieldValue: email.text);
    if (customer == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing...')));
      await CustomerService().create(Customer(
          firstName: firstName.text,
          lastName: lastName.text,
          email: email.text));

      Navigator.pop(context);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Customer already exists')));
    }
  }

  Widget get submitButton => Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _createCustomer(context);
                }
              },
              child: Text('Save')),
        );
      });

  Widget get cancelButton => Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        );
      });

  Widget get customerForm => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildInput("First Name", firstName),
              buildInput("Last Name", lastName),
              buildInput("Email", email),
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
