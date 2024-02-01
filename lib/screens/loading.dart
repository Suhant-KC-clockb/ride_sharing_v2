import 'package:flutter/material.dart';

//TODO: Complete this page
class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/iamges/getting_started.png"),
        ],
      ),
    );
  }
}
