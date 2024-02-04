import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/routes.dart';

class RiderDashboardDetail extends ConsumerStatefulWidget {
  const RiderDashboardDetail({Key? key}) : super(key: key);

  @override
  _RiderDashboardState createState() => _RiderDashboardState();
}

class _RiderDashboardState extends ConsumerState<RiderDashboardDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Text("Rider Dashboard"),
          ),
          ref.watch(getAuthenticatedUserProvider).when(
                data: (data) => Text(data.name!),
                error: (error, stackTrace) =>
                    const Text("Something went wrong"),
                loading: () => const CircularProgressIndicator(),
              ),
          ElevatedButton(
              onPressed: () async {
                final isCleared = await ref.read(resetStorage);
                if (isCleared) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Pathname.otpScreen, (route) => false);
                }
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
