import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer.dart';

/*
 * Copyright (C) 2019-2020, Anurag Sharma
 * All rights reserved.
 */
class CustomerService {
  final CollectionReference ref = Firestore.instance.collection("customers");

  Future<Customer> findByField({var fieldName, var fieldValue}) async {
    QuerySnapshot query =
        await ref.where(fieldName, isEqualTo: fieldValue).getDocuments();
    List<Customer> customers = query.documents
        .map(
            (snapshot) => Customer.fromJson(snapshot.documentID, snapshot.data))
        .toList();
    if (customers.length > 0) {
      return customers[0];
    } else {
      return null;
    }
  }

  Future<Customer> find(var id) async {
    DocumentSnapshot snapshot = await ref.document(id).get();
    return Customer.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<Customer> create(Customer customer) async {
    var docRef = await ref.add(customer.toJson());
    var snapshot = await docRef.get();
    return Customer.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> update(var id, Customer customer) async {
    return await ref.document(id).updateData(customer.toJson());
  }

  Future<void> delete(var id) async {
    return await ref.document(id).delete();
  }

  Stream<List<Customer>> list({var limit = 10, var lastKey}) {
    return ref.limit(limit).snapshots().map((QuerySnapshot query) => query
        .documents
        .map(
            (snapshot) => Customer.fromJson(snapshot.documentID, snapshot.data))
        .toList());

    /*return ref.getDocuments().then((QuerySnapshot query) {
      print("Found query result");
      return query.documents
          .map((snapshot) => Customer.fromJson(snapshot))
          .toList();
    });*/
    /*.orderBy("customerId")
        .limit(limit)
        .startAt(lastKey)
        .getDocuments();
    print("Query: $query");
    return query.documents
        .map((snapshot) => Customer.fromJson(snapshot))
        .toList();*/
  }
}
