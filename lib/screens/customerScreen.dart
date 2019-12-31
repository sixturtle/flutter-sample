import 'package:flutter/material.dart';

import 'customerForm.dart';
import 'memberScreen.dart';
import '../services/customerService.dart';
import '../models/user.dart';
import '../models/customer.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class CustomerScreen extends StatefulWidget {
  final User currentUser;

  CustomerScreen({Key key, @required this.currentUser}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  Stream<List<Customer>> customers;

  @override
  void initState() {
    super.initState();
    customers = CustomerService().list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar, body: customerList, floatingActionButton: addButton);
  }

  Widget get customerList {
    return StreamBuilder<List<Customer>>(
      stream: customers,
      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int count = snapshot.data.length;
        return ListView.builder(
            itemCount: count,
            itemBuilder: (context, int index) {
              final Customer customer = snapshot.data[index];
              return buildCustomerCard(customer);
            });
      },
    );
  }

  Widget buildCustomerCard(Customer customer) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MemberScreen(customer)))
      },
      child: Card(
        child: ListTile(
          title: Text(customer.lastName + ', ' + customer.firstName),
          subtitle: Text(
              "Balance: ${customer.openingBalance}, ${customer.closingBalance}"),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  Widget get loggedInUser => CircleAvatar(
      radius: 30.0,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(widget.currentUser.photoUrl));

  Widget get logoutButon => Builder(builder: (BuildContext context) {
        return IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pop(context);
            });
      });

  Widget get appBar => AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null),
        title: Text('BSA Troop 158'),
        actions: <Widget>[loggedInUser, logoutButon],
      );

  Widget get addButton => Builder(builder: (BuildContext context) {
        return FloatingActionButton(
            onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CustomerForm()))
                },
            child: Icon(Icons.add),
            backgroundColor: Colors.green);
      });
}
