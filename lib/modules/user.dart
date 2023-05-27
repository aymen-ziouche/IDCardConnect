import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String cardGender;
  final String gender;
  final String mobile;
  final String firstname;
  final String lastname;
  final String country;
  final String nationality;
  final String doc_code;
  final String doc_num;
  final String date_of_birth;
  final String date_of_expiry;
  final Uint8List? image;

  User({
    this.uid = '',
    this.name = '',
    this.email = '',
    this.cardGender = '',
    this.gender = '',
    this.mobile = '',
    this.firstname = '',
    this.lastname = '',
    this.country = '',
    this.nationality = '',
    this.doc_code = '',
    this.doc_num = '',
    this.date_of_birth = '',
    this.date_of_expiry = '',
    this.image,
  });

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      uid: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      cardGender: data['cardGender'] ?? '',
      gender: data['gender'] ?? '',
      mobile: data['mobile'] ?? '',
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      country: data['country'] ?? '',
      nationality: data['nationality'] ?? '',
      doc_code: data['doc_code'] ?? '',
      doc_num: data['doc_num'] ?? '',
      date_of_birth: data['date_of_birth'] ?? '',
      date_of_expiry: data['date_of_expiry'] ?? '',
      image: data['image'] != null
          ? Uint8List.fromList(data['image'].cast<int>())
          : Uint8List(0),
    );
  }
}
