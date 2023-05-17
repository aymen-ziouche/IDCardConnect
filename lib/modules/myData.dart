class MyData {
  String firstname;
  String lastname;
  String country;
  String nationality;
  String doc_code;
  String doc_num;
  String date_of_birth;
  String date_of_expiry;

  MyData({
    required this.firstname,
    required this.lastname,
    required this.country,
    required this.nationality,
    required this.doc_code,
    required this.doc_num,
    required this.date_of_birth,
    required this.date_of_expiry,
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