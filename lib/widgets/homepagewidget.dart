
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


Widget HomePageWidget(String name, RiveAnimation animation) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                blurRadius: 7,
                color: Colors.black12,
                spreadRadius: 2.0,
                offset: Offset(0.2, 0.2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Center(
              widthFactor: 2,
              child: animation,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      ),
    ),
  );
}

Widget HomePageWidgett(String name, IconData icon) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                blurRadius: 7,
                color: Colors.black12,
                spreadRadius: 2.0,
                offset: Offset(0.2, 0.2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Center(
              widthFactor: 2,
              child: Icon(icon, size: 40),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      ),
    ),
  );
}
