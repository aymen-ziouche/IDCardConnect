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
      "gender": mydata.gender,
      "doc_code": mydata.doc_code,
      "doc_num": mydata.doc_num,
      "National identification number": mydata.doc_longNumber,
      "wilaya": mydata.wilaya,
      "date_of_birth": mydata.date_of_birth,
      "place_of_birth": mydata.place_of_birth,
      "bloodType": mydata.bloodType,
      "date_of_creation": mydata.date_of_creation,
      "date_of_expiry": mydata.date_of_expiry,
      "image": mydata.image,
    });
  }

  Future<void> updateinfo(
    String name,
    String email,
    String password,
  ) async {
    final user = _auth.currentUser;
    final credential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      await user!.reauthenticateWithCredential(credential);
      // Save the user's information on Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
      });
      print('Name updated successfully');
    } catch (e) {
      print('Error updating Name: $e');
    }
  }

  Future<void> updateEmail(
    String email,
    String newemail,
    String password,
  ) async {
    final user = _auth.currentUser;
    final credential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      await user!.reauthenticateWithCredential(credential);

      await user.updateEmail(newemail);

      await _firestore.collection('users').doc(user.uid).update({
        'email': newemail,
      });

      print('Email updated successfully');
      print(newemail);
    } catch (e) {
      print('Error updating email : $e');
    }
    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user!.uid).update({
      'email': email,
    });
  }

  Future<void> updatePass(
      String email, String password, String newpassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User not authenticated');
      return;
    }

    final credential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      await user.reauthenticateWithCredential(credential);
      print("Print my new password: " + newpassword);

      await user.updatePassword(newpassword);
      print("Password updated!");

      print('Password updated successfully');
      print("Print my new password: " + newpassword);
    } catch (e) {
      print('Error updating password: $e');
      print("Print my new password: " + newpassword);
    }
  }

  Future<void> delete() async {
    final user = _auth.currentUser;

    await _firestore.collection('users').doc(user?.uid).delete();
  }
}
