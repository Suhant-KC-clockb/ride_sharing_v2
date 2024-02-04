import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ridesharing/data/models/user.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/screens/auth/otp_screen.dart';
import 'package:ridesharing/screens/auth/sign_up.dart';
import 'package:ridesharing/screens/rider/rider_dashboard.dart';
import 'package:ridesharing/screens/user/user_dashboard.dart';
import 'package:ridesharing/utils/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Ride Sharing App',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      home: ref.watch(getAuthenticatedUserProvider).when(
            data: (User user) => user.role == "user"
                ? const UserDashboard()
                : user.role == "rider"
                    ? const RiderDashboard()
                    : user.role == ""
                        ? const SignUp()
                        : const OtpScreen(),
            error: (error, stackTrace) => const OtpScreen(),
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
