import 'package:flutter/material.dart';
import 'package:ridesharing/screens/auth/getting_started.dart';
import 'package:ridesharing/screens/auth/otp_confirmation.dart';
import 'package:ridesharing/screens/auth/otp_screen.dart';
import 'package:ridesharing/screens/auth/sign_up.dart';
import 'package:ridesharing/screens/loading.dart';
import 'package:ridesharing/screens/rider/rider_dashboard.dart';
import 'package:ridesharing/screens/user/user_dashboard.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Pathname.otpScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(),
        );
      case Pathname.gettingStarted:
        return MaterialPageRoute(
          builder: (context) => const GettingStarted(),
        );
      case Pathname.otpConfirmation:
        return MaterialPageRoute(
          builder: (context) => const OtpConfirmation(),
        );
      case Pathname.signUp:
        return MaterialPageRoute(
          builder: (context) => const SignUp(),
        );
      case Pathname.loading:
        return MaterialPageRoute(
          builder: (context) => const Loading(),
        );

      //User Dashboard
      case Pathname.userDashboard:
        return MaterialPageRoute(
          builder: (context) => const UserDashboard(),
        );

      //Rider Dashboard
      case Pathname.riderDashboard:
        return MaterialPageRoute(
          builder: (context) => const RiderDashboard(),
        ); //If no routes are found it will redirect to this error page
      //TODO: Beautify this error Page
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
              centerTitle: true,
            ),
            body: const Center(
              child: Text("Page not found"),
            ),
          ),
        );
    }
  }
}

class Pathname {
  //Auth Page Routes
  static const otpScreen = "/otp_screen";
  static const homepage = "/homepage";
  static const gettingStarted = "/gettingStarted";
  static const otpConfirmation = "/otpConfirmationScreen";
  static const signUp = "/sign-up";
  static const loading = '/loading';

  //User routes
  static const userDashboard = "/user-dashboard";

  //Rider Routes
  static const riderDashboard = '/rider-dashboard';
}
