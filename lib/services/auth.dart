import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp(String email, String password, String name,
      String mobile, String gender) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    final user = authResult.user;

    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user?.uid).set({
      'name': name,
      'email': email,
      'mobile': mobile,
      'gender': gender,
    });
    return authResult;
  }

  Future<UserCredential> signIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> logout() async => await _auth.signOut();
}
