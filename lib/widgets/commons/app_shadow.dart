import 'package:flutter/material.dart';

BoxDecoration appBoxShadow(
    {Color color = Colors.white,
    double radius = 15,
    double sR = 1,
    double bR = 2}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: sR,
        blurRadius: bR,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
