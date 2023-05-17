import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nfc_id_reader/modules/myData.dart';

class Database {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveinfo(MyData mydata) async {
    final user = _auth.currentUser;

    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user?.uid).update({
      "firstname": mydata.firstname,
      "lastname": mydata.lastname,
      "country": mydata.country,
      "nationality": mydata.nationality,
      "doc_code": mydata.doc_code,
      "doc_num": mydata.doc_num,
      "date_of_birth": mydata.date_of_birth,
      "date_of_expiry": mydata.date_of_expiry,
    });
  }

  Future<void> updateinfo(String name, String email) async {
    final user = _auth.currentUser;

    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user?.uid).update({
      'name': name,
      'email': email,
    });
  }
}
