import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardPage extends StatefulWidget {
  UserProvider myprovider;
  CardPage({super.key, required this.myprovider});
  static String id = "CardPage";

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity - 40,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 195, 209, 195),
                            Color.fromARGB(255, 90, 114, 94),
                          ]),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.grey,
                          blurRadius: 15,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.myprovider.user!.country,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(widget.myprovider.user!.wilaya,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(widget.myprovider.user!.doc_num,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                  ],
                                ),
                                Text(widget.myprovider.user!.doc_longNumber,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: SizedBox(
                                      height: 120,
                                      child: Image.memory(widget
                                          .myprovider.user!.image as Uint8List),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          textAlign: TextAlign.start,
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Full Name : ",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text: widget.myprovider.user!
                                                        .firstname +
                                                    " " +
                                                    widget.myprovider.user!
                                                        .lastname,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Birth date : ",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: widget.myprovider.user!
                                                      .date_of_birth,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Creation date : ",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: widget.myprovider.user!
                                                      .date_of_creation,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Expires date : ",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: widget.myprovider.user!
                                                      .date_of_expiry,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Gender : ",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: widget.myprovider.user!
                                                      .cardGender,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.18,
                    child: Container(
                      width: double.infinity - 40,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [],
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 124, 151, 125),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "You Can Scan the QR Code",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            QrImageView(
              data: '''
        Firstname: ${widget.myprovider.user!.firstname},
        Lastname: ${widget.myprovider.user!.lastname}
        Country: ${widget.myprovider.user!.country},
        place of extraction: ${widget.myprovider.user!.wilaya},
        Gender: ${widget.myprovider.user!.gender},
        Nationality: ${widget.myprovider.user!.nationality},
        Document Type: ${widget.myprovider.user!.doc_code},
        Document Number: ${widget.myprovider.user!.doc_num},
        National identification Number: ${widget.myprovider.user!.doc_longNumber},
        Date of Birth: ${widget.myprovider.user!.date_of_birth},
        Date of Creation: ${widget.myprovider.user!.date_of_creation},
        Date of Expiry: ${widget.myprovider.user!.date_of_expiry},''',
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
