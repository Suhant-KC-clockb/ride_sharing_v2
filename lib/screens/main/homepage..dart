import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              // Provider.of<Auth>(context, listen: false).logout();
            },
            child: Text("Logout"),
          )
        ],
      ),
    );
  }
}
