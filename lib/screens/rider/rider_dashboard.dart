import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/screens/rider/widgets/rider_dashboard.dart';
import 'package:ridesharing/screens/rider/widgets/rider_form.dart';
import 'package:ridesharing/widgets/commons/loading_spinner.dart';

class RiderDashboard extends ConsumerWidget {
  const RiderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getRiderDetail).when(
          data: (data) => data.fold(
            (l) => const RiderForm(),
            (r) => const RiderDashboardDetail(),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          ),
          loading: () => Scaffold(
            body: Center(
              child: pageLoading(context: context),
            ),
          ),
        );
  }
}
