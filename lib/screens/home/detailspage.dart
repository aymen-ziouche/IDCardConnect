import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dmrtd/dmrtd.dart';

import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:nfc_id_reader/modules/myData.dart';
import 'package:nfc_id_reader/services/database.dart';
import 'package:nfc_id_reader/widgets/mainButton.dart';

Widget makeMrtdDataWidget(
    {required String header, required String collapsedText, required MRZ mrz}) {
  MyData user_data = MyData(
      firstname: mrz.firstName,
      lastname: mrz.lastName,
      country: mrz.country,
      nationality: mrz.nationality,
      doc_code: mrz.documentCode,
      doc_num: mrz.documentNumber,
      date_of_birth: '${DateFormat.yMd().format(mrz.dateOfBirth)}',
      date_of_expiry: '${DateFormat.yMd().format(mrz.dateOfExpiry)}');
  final _db = Database();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        header,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextButton(
        child: const Text('Copy'),
        onPressed: () =>
            Clipboard.setData(ClipboardData(text: user_data.toString())),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [const Text("First Name:"), Text(user_data.firstname)],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [const Text("Last Name:"), Text(user_data.lastname)],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Country:"),
          Text(user_data.country),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Nationality:"),
          Text(user_data.nationality),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Document Code:"),
          Text(user_data.doc_code),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Document Number:"),
          Text(user_data.doc_num),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Date of Birth:"),
          Text(user_data.date_of_birth),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Date of expiry:"),
          Text(user_data.date_of_expiry),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
      MainButton(
          hasCircularBorder: true,
          text: "Save your Info",
          onTap: () {
            _db.saveinfo(user_data);
          }),
      const Divider(),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}
