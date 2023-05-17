import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String profilePicture;
  final String firstname;
  final String lastname;
  final String country;
  final String nationality;
  final String doc_code;
  final String doc_num;
  final String date_of_birth;
  final String date_of_expiry;

  User({
    this.uid = '',
    this.name = '',
    this.email = '',
    this.profilePicture = '',
    this.firstname = '',
    this.lastname = '',
    this.country = '',
    this.nationality = '',
    this.doc_code = '',
    this.doc_num = '',
    this.date_of_birth = '',
    this.date_of_expiry = '',
  });

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      uid: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicture: data['profile_picture'] ?? '',
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      country: data['country'] ?? '',
      nationality: data['nationality'] ?? '',
      doc_code: data['doc_code'] ?? '',
      doc_num: data['doc_num'] ?? '',
      date_of_birth: data['date_of_birth'] ?? '',
      date_of_expiry: data['date_of_expiry'] ?? '',
    );
  }
}
