import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/routes.dart';

class RiderForm extends ConsumerStatefulWidget {
  const RiderForm({Key? key}) : super(key: key);

  @override
  _RiderFormState createState() => _RiderFormState();
}

class _RiderFormState extends ConsumerState<RiderForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Rider Detail",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Pathname.riderVehiclesInformation);
              },
              child: const ListTile(
                leading: Icon(CupertinoIcons.car_detailed),
                title: Text("Vehicle Information"),
                subtitle: Text(
                  "Enter your vehicle detail",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Pathname.riderLicenseInformation);
              },
              child: const ListTile(
                leading: Icon(CupertinoIcons.doc_person_fill),
                title: Row(
                  children: [Text("License Information")],
                ),
                subtitle: Text(
                  "Upload your license",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Pathname.riderBluebookInformation);
              },
              child: const ListTile(
                leading: Icon(CupertinoIcons.doc_circle),
                subtitle: Text(
                  "Upload your Bluebook information",
                  style: TextStyle(fontSize: 12),
                ),
                title: Text("Bluebook Information"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ));
  }
}
