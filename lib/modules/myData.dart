import 'dart:typed_data';

class MyData {
  String firstname;
  String lastname;
  String country;
  String nationality;
  String doc_code;
  String doc_num;
  String doc_longNumber;
  String date_of_birth;
  String date_of_creation;
  String date_of_expiry;
  String wilaya;
  String bloodType;
  String place_of_birth;
  Uint8List image;
  String gender;

  MyData({
    required this.firstname,
    required this.lastname,
    required this.country,
    required this.nationality,
    required this.doc_code,
    required this.doc_num,
    required this.doc_longNumber,
    required this.date_of_birth,
    required this.date_of_creation,
    required this.date_of_expiry,
    required this.wilaya,
    required this.bloodType,
    required this.place_of_birth,
    required this.image,
    required this.gender,
  });
}

// String formatMRZ(final MRZ mrz) {
//   return " doc code: ${mrz.documentCode}\n  
//doc No.: ${mrz.documentNumber}\n  
//country: ${mrz.country}\n  
//nationality: ${mrz.nationality}\n  
//First Name: ${mrz.firstName}\n  
//Last Name: ${mrz.lastName}\n  
//gender: ${mrz.gender}\n  
//date of birth: ${DateFormat.yMd().format(mrz.dateOfBirth)}\n  
//date of expiry: ${DateFormat.yMd().format(mrz.dateOfExpiry)}";
// }