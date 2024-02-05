import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/constant.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/commons/gap.dart';
import 'package:ridesharing/widgets/commons/loading_spinner.dart';
import 'package:ridesharing/widgets/commons/snackbar.dart';
import 'package:ridesharing/widgets/display_image.dart';

class LicenseInfo extends ConsumerStatefulWidget {
  const LicenseInfo({Key? key}) : super(key: key);

  @override
  LicenseInfoState createState() => LicenseInfoState();
}

class LicenseInfoState extends ConsumerState<LicenseInfo> {
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  //Front image
  XFile? _licenseFront;
  bool imageFrontError = false;
  String? frontDriverAPI;

  //Holding License image
  XFile? _licenseHolding;
  bool imageHoldingError = false;
  String? imageHoldingAPI;

  Future<void> getData() async {
    final response =
        await ref.read(riderController.notifier).fetchRiderDetail();

    response.fold((l) => null, (r) {
      setState(() {
        if (r.licenseFrontImg != null) {
          frontDriverAPI = r.licenseFrontImgUrl;
        }
        if (r.riderHoldingLicenseImg != null) {
          imageHoldingAPI = r.riderHoldingLicenseImgUrl;
        }
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getFrontImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    var imagePath = await image!.readAsBytes();

    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      setState(() {
        _licenseFront = image;
        imageFrontError = false;
      });
    } else {
      setState(() {
        imageFrontError = true;
      });
      if (!mounted) return;
      customSnackBar(
          title: "Error",
          message: "Please select image less than 5MB",
          context: context);
    }
  }

  Future getLicenseHolding() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    var imagePath = await image!.readAsBytes();

    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      setState(() {
        _licenseHolding = image;
        imageHoldingError = false;
      });
    } else {
      setState(() {
        imageHoldingError = true;
      });
      if (!mounted) return;
      customSnackBar(
          title: "Error",
          message: "Please select image less than 5MB",
          context: context);
    }
  }

  void submitButton() async {
    if ((_licenseHolding == null && imageHoldingAPI == null) ||
        (_licenseFront == null && frontDriverAPI == null)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await ref
        .read(riderController.notifier)
        .postRiderLicenseDetail(
          front: _licenseFront != null ? File(_licenseFront!.path) : null,
          holding: _licenseHolding != null ? File(_licenseHolding!.path) : null,
        );

    response.fold(
      (l) => customSnackBar(
        title: "Error",
        message: l,
        context: context,
        contentType: ContentType.failure,
      ),
      (r) {
        customSnackBar(
          title: "Form updated!",
          message: "Please fill out the next form too!",
          context: context,
        );

        Navigator.pushReplacementNamed(
            context, Pathname.riderBluebookInformation);
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("License Information"),
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
                      const Text("The front driver's license"),
                      SizedBox(
                        height: 150,
                        child: displayImage(
                            svgImage: "assets/images/pfp.svg",
                            apiImage: frontDriverAPI,
                            image: _licenseFront),
                      ),
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
                          child: const Text("Add Photo"))
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
                      const Text("Your photo while holding license"),
                      SizedBox(
                        height: 150,
                        child: displayImage(
                            svgImage: "assets/images/pfp.svg",
                            apiImage: imageHoldingAPI,
                            image: _licenseHolding),
                        // child: (_licenseHolding != null)
                        //     ? Image.file(
                        //         File(_licenseHolding!.path),
                        //       )
                        //     : SvgPicture.asset('assets/images/pfp.svg',
                        //         semanticsLabel: 'Acme Logo'),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: getLicenseHolding,
                          child: const Text("Add Photo"))
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
