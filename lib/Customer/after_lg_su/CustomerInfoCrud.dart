import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerInfoCrud {
  createCustomer(id, customerData) {
    Firestore.instance
        .collection('customer')
        .document(id)
        .setData(customerData)
        .catchError((e) => print(e));
  }

  getCustomer(id) async {
    return await Firestore.instance.collection('customer').document(id).get();
  }

  upDateCustomerData(id, customerData) {
    Firestore.instance
        .collection('customer')
        .document(id)
        .updateData(customerData)
        .catchError((e) => print(e));
  }

  getSellers() async {
    return await Firestore.instance.collection('seller').getDocuments();
  }
}