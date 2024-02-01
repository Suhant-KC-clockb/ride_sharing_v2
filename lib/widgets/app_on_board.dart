import 'package:flutter/material.dart';
import 'package:ridesharing/utils/mediaquery.dart';

Widget appOnBoaringPage(
  BuildContext context, {
  String imagePath = "assets/images/reading.png",
  String title = "",
  String subTitle = "",
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        imagePath,
        height: getHeight(context) * 0.4,
        fit: BoxFit.contain,
      ),
      Container(
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
