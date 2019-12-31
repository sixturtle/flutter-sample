import 'package:flutter/material.dart';

import 'memberForm.dart';
import '../services/memberService.dart';
import '../models/customer.dart';
import '../models/member.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class MemberScreen extends StatefulWidget {
  final Customer customer;
  const MemberScreen(this.customer);

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  Stream<List<Member>> members;

  @override
  void initState() {
    super.initState();
    members = MemberService().listByCustomerId(widget.customer.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("${widget.customer.lastName}, ${widget.customer.firstName}"),
        ),
        body: memberList,
        floatingActionButton: addMemberButton);
  }

  Widget get memberList {
    return StreamBuilder<List<Member>>(
      stream: members,
      builder: (BuildContext context, AsyncSnapshot<List<Member>> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int count = snapshot.data.length;
        return ListView.builder(
          itemCount: count,
          itemBuilder: (_, int index) {
            final Member member = snapshot.data[index];
            return buildMemberCard(context, member);
          },
        );
      },
    );
  }

  Widget buildMemberCard(BuildContext context, Member member) {
    return Card(
      child: ListTile(
        title: Text(member.lastName + ', ' + member.firstName),
        subtitle: Text("Since: ${member.joiningDate}"),
        trailing: /*Row(
            children: <Widget>[*/
            InkWell(
                onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MemberForm(
                              customer: widget.customer, member: member)))
                    },
                child: Icon(Icons.edit)),
        /*SizedBox(width: 30),
               InkWell(
                  onTap: () async => await MemberService().delete(member.id),
                  child: Icon(Icons.delete_forever))*/
        /*]),*/
      ),
    );
  }

  Widget get addMemberButton => Builder(builder: (BuildContext context) {
        return FloatingActionButton(
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MemberForm(customer: widget.customer)))
                },
            child: Icon(Icons.add),
            backgroundColor: Colors.green);
      });
}
