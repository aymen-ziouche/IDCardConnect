import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dmrtd/dmrtd.dart';

import 'package:intl/intl.dart';
import 'package:nfc_id_reader/modules/myData.dart';
import 'package:nfc_id_reader/services/database.dart';
import 'package:nfc_id_reader/widgets/mainButton.dart';

class MakeMrtdDataWidget extends StatefulWidget {
  String header;
  MRZ mrz;
  String date_of_creation;
  String longNumber;
  String wilaya;
  String bloodType;
  String pob;
  Uint8List image;
  MakeMrtdDataWidget({
    super.key,
    required this.header,
    required this.mrz,
    required this.date_of_creation,
    required this.longNumber,
    required this.wilaya,
    required this.bloodType,
    required this.pob,
    required this.image,
  });

  @override
  State<MakeMrtdDataWidget> createState() => _MakeMrtdDataWidgetState();
}

class _MakeMrtdDataWidgetState extends State<MakeMrtdDataWidget> {
  final _db = Database();
  @override
  Widget build(BuildContext context) {
    MyData user_data = MyData(
        firstname: widget.mrz.firstName,
        lastname: widget.mrz.lastName,
        country: widget.mrz.country,
        gender: widget.mrz.gender,
        nationality: widget.mrz.nationality,
        doc_code: widget.mrz.documentCode,
        doc_num: widget.mrz.documentNumber,
        doc_longNumber: widget.longNumber,
        date_of_birth: DateFormat.yMd().format(widget.mrz.dateOfBirth),
        date_of_creation: widget.date_of_creation,
        date_of_expiry: DateFormat.yMd().format(widget.mrz.dateOfExpiry),
        wilaya: widget.wilaya,
        bloodType: widget.bloodType,
        place_of_birth: widget.pob,
        image: widget.image);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.header,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
          child: const Text('Copy'),
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: widget.mrz.toString())),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 150,
          child: Image.memory(widget.image),
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
            const Text("Gender:"),
            Text(user_data.gender),
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
            const Text("National identification number:"),
            Flexible(child: Text(user_data.doc_longNumber)),
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
            const Text("Place of extraction:"),
            Text(user_data.wilaya),
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
            const Text("Date of Creation:"),
            Text(user_data.date_of_creation),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Place of birth:"),
            Text(user_data.place_of_birth),
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
            const Text("Blood Type:"),
            Text(user_data.bloodType),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Your Data is Saved",
                  ),
                ),
              );
              _db.saveinfo(user_data);
            }),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
