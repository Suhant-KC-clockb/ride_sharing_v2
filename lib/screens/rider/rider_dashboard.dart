import 'package:flutter/material.dart';
import 'package:ridesharing/routes.dart';

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text("Rider Dashboard"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Pathname.otpScreen, (route) => false);
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
