import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_id_reader/modules/user.dart';
import 'package:nfc_id_reader/services/auth.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  String userid = Auth().currentUser!.uid;

  Future<void> fetchUser() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    _user = User.fromFirestore(snapshot);

    notifyListeners();
  }
}
