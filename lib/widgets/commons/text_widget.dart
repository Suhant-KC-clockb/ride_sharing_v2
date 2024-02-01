import 'package:flutter/material.dart';

Widget text24Normal({String text = "", Color color = Colors.black}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget text16Normal({String text = "", Color color = Colors.grey}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  );
}
