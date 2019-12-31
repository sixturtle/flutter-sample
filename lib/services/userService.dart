import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class UserService {
  final CollectionReference ref = Firestore.instance.collection("users");

  Future<User> findByUserId(var userId) async {
    QuerySnapshot query =
        await ref.where('userId', isEqualTo: userId).getDocuments();
    List<User> users = query.documents
        .map((snapshot) => User.fromJson(snapshot.documentID, snapshot.data))
        .toList();
    if (users.length > 0) {
      return users[0];
    } else {
      return null;
    }
  }

  Future<User> find(var documentID) async {
    DocumentSnapshot snapshot = await ref.document(documentID).get();
    return User.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<User> create(User user) async {
    var docRef = await ref.add(user.toJson());
    var snapshot = await docRef.get();
    return User.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> update(var documentID, User user) async {
    await ref.document(documentID).updateData(user.toJson());
  }

  Future<void> delete(var documentID) async {
    await ref.document(documentID).delete();
  }

  Stream<List<User>> list({var limit = 10, var lastKey}) {
    return ref.limit(limit).snapshots().map((QuerySnapshot query) => query
        .documents
        .map((snapshot) => User.fromJson(snapshot.documentID, snapshot.data))
        .toList());

    /*QuerySnapshot query = await ref
        .orderBy("displayName")
        .limit(limit)
        .startAt(lastKey)
        .getDocuments();
    return query.documents.map((snapshot) => User.fromJson(snapshot.documentID, snapshot)).toList();*/
  }
}
