import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/constant.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/commons/gap.dart';
import 'package:ridesharing/widgets/commons/loading_spinner.dart';

class BluebookInfo extends ConsumerStatefulWidget {
  const BluebookInfo({Key? key}) : super(key: key);

  @override
  _LicenseInfoState createState() => _LicenseInfoState();
}

class _LicenseInfoState extends ConsumerState<BluebookInfo> {
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  //Front image
  XFile? _bluebook1;
  bool imageFrontError = false;

  //Back image
  XFile? _bluebook2;
  bool imageBackError = false;

  //Vehicle Image
  XFile? _vehicleImage;
  bool imageError = false;

  Future getFrontImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    var imagePath = await image!.readAsBytes();

    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      setState(() {
        _bluebook1 = image;
        imageFrontError = false;
      });
    } else {
      setState(() {
        imageFrontError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select image lesser than 5 MB"),
        ),
      );
    }
  }

  Future getBackImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    var imagePath = await image!.readAsBytes();

    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      setState(() {
        _bluebook2 = image;
        imageBackError = false;
      });
    } else {
      setState(() {
        imageBackError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select image lesser than 5 MB"),
        ),
      );
    }
  }

  void submitButton() async {
    if (_bluebook2 == null) {
      return;
    }
    if (_bluebook1 == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response =
        //     await ref.read(riderController.notifier).postRiderLicenseDetail(
        //           back: File(_licenseBack!.path),
        //           front: File(_licenseFront!.path),
        //         );
        // response.fold(
        //   (l) => print(l),
        //   (r) => Navigator.pushReplacementNamed(
        //       context, Pathname.riderLicenseInformation),
        // );

        setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluebook Information"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: getWidth(context) * 0.9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Billbook (नामसारी भएको फोटो)"),
                      SizedBox(
                          height: 150,
                          child: (_bluebook1 != null)
                              ? Image.file(
                                  File(_bluebook1!.path),
                                )
                              : SvgPicture.asset('assets/images/pfp.svg',
                                  semanticsLabel: 'Acme Logo')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: getFrontImage,
                          child: Text("Add Photo"))
                    ],
                  ),
                ),
              ),
              gap10(),
              Center(
                child: Container(
                  height: 300,
                  width: getWidth(context) * 0.9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Billbook (सवारीको विस्तृत विवरण)"),
                      SizedBox(
                          height: 150,
                          child: (_bluebook2 != null)
                              ? Image.file(
                                  File(_bluebook2!.path),
                                )
                              : SvgPicture.asset('assets/images/pfp.svg',
                                  semanticsLabel: 'Acme Logo')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: getBackImage,
                          child: Text("Add Photo"))
                    ],
                  ),
                ),
              ),
              gap20(),
              Center(
                child: SizedBox(
                  width: getWidth(context) * 0.9,
                  child: ElevatedButton(
                    onPressed: !isLoading ? submitButton : null,
                    child: !isLoading ? const Text("Next") : buttonLoading(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
