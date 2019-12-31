import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class MemberService {
  final CollectionReference ref = Firestore.instance.collection("members");

  Future<Member> findByField({var fieldName, var fieldValue}) async {
    QuerySnapshot query =
        await ref.where(fieldName, isEqualTo: fieldValue).getDocuments();
    List<Member> members = query.documents
        .map((snapshot) => Member.fromJson(snapshot.documentID, snapshot.data))
        .toList();
    if (members.length > 0) {
      return members[0];
    } else {
      return null;
    }
  }

  Stream<List<Member>> listByCustomerId(var customerId,
      {var limit = 10, Member lastKey}) {
    return ref
        .limit(limit)
        .where("customerId", isEqualTo: customerId)
        .snapshots()
        .map((QuerySnapshot query) => query.documents
            .map((snapshot) =>
                Member.fromJson(snapshot.documentID, snapshot.data))
            .toList());
    /*
    QuerySnapshot query = await ref
        .where("customerId", isEqualTo: "customers/" + customerId)
        .limit(limit)
        .startAt([lastKey]).getDocuments();
    List<Member> members =
        query.documents.map((snapshot) => Member.fromJson(snapshot)).toList();
    return members;*/
  }

  Future<Member> find(var id) async {
    DocumentSnapshot snapshot = await ref.document(id).get();
    return Member.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<Member> create(Member member) async {
    var docRef = await ref.add(member.toJson());
    var snapshot = await docRef.get();
    return Member.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> update(var id, Member member) async {
    await ref.document(id).updateData(member.toJson());
  }

  Future<void> delete(var id) async {
    await ref.document(id).delete();
  }

  Future<List<Member>> list({var limit = 10, var lastKey}) async {
    QuerySnapshot query =
        await ref.orderBy("id").limit(limit).startAt(lastKey).getDocuments();
    return query.documents
        .map((snapshot) => Member.fromJson(snapshot.documentID, snapshot.data))
        .toList();
  }
}
