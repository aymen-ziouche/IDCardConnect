import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
    String gender = widget.myprovider.user!.gender;

    var arr = gender.split('.');

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity - 40,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: const [
                            Color.fromARGB(255, 195, 209, 195),
                            Color.fromARGB(255, 90, 114, 94),
                          ]),
                      boxShadow: [
                        BoxShadow(
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
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.myprovider.user!.country,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(widget.myprovider.user!.doc_num,
                                    style: TextStyle(
                                        fontSize: 20,
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        textAlign: TextAlign.start,
                                        TextSpan(
                                          children: [
                                            TextSpan(
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
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Birth date : ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: widget.myprovider.user!
                                                    .date_of_birth,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Expires date : ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: widget.myprovider.user!
                                                    .date_of_expiry,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Gender : ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: arr[0],
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
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
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [],
                            colors: const [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 124, 151, 125),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
