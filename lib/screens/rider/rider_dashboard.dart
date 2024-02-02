import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/routes.dart';

class RiderDashboard extends ConsumerWidget {
  const RiderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text("Rider Dashboard"),
          ),
          ref.watch(getAuthenticatedUserProvider).when(
                data: (data) => Text(data.name!),
                error: (error, stackTrace) => Text("Something went wrong"),
                loading: () => CircularProgressIndicator(),
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
