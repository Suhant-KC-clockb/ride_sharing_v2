import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/routes.dart';

class UserDashboard extends ConsumerWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Text("User Dashboard"),
          ),
          ref.watch(getAuthenticatedUserProvider).when(
                data: (data) => Text("${data.id}"),
                error: (error, stackTrace) =>
                    const Text("Something went wrong"),
                loading: () => const CircularProgressIndicator(),
              ),
          ElevatedButton(
              onPressed: () async {
                final isCleared = await ref.read(resetStorage);
                if (isCleared) {
                  Navigator.popAndPushNamed(context, Pathname.otpScreen);
                }
                // context.read<Auth>().logout();
                // Navigator.pushNamedAndRemoveUntil(
                // context, Pathname.otpScreen, (route) => false);
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
