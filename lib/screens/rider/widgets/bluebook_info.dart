import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/constant.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/commons/gap.dart';
import 'package:ridesharing/widgets/commons/loading_spinner.dart';
import 'package:ridesharing/widgets/commons/snackbar.dart';
import 'package:ridesharing/widgets/display_image.dart';

class BluebookInfo extends ConsumerStatefulWidget {
  const BluebookInfo({Key? key}) : super(key: key);

  @override
  LicenseInfoState createState() => LicenseInfoState();
}

class LicenseInfoState extends ConsumerState<BluebookInfo> {
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  //Front image
  XFile? _bluebook1;
  bool imageFrontError = false;
  String? blueBook1API;

  //Back image
  XFile? _bluebook2;
  bool imageBackError = false;
  String? blueBook2API;

  Future<void> getData() async {
    final response =
        await ref.read(riderController.notifier).fetchRiderDetail();

    response.fold((l) => null, (r) {
      setState(() {
        if (r.blueBook1Img != null) {
          blueBook1API = r.blueBook1ImgUrl;
        }
        if (r.blueBook2Img != null) {
          blueBook2API = r.blueBook2ImgUrl;
        }
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getBluebookImage() async {
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
      if (!mounted) return;
      imageErrorSnackbar(context: context);
    }
  }

  Future getBluebookImage2() async {
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
      if (!mounted) return;
      imageErrorSnackbar(context: context);
    }
  }

  void submitButton() async {
    if ((_bluebook2 == null && blueBook1API == null) ||
        (_bluebook1 == null && blueBook2API == null)) {
      imageErrorSnackbar(
        context: context,
        title: "No photo",
        message: _bluebook2 == null
            ? "Please enter your bluebook photo"
            : "Please enter your bluebook photo no 2",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response =
        await ref.read(riderController.notifier).postRiderBluebookDetail(
              bluebook1: _bluebook1 != null ? File(_bluebook1!.path) : null,
              bluebook2: _bluebook2 != null ? File(_bluebook2!.path) : null,
            );

    response.fold(
      (l) => customSnackBar(
        title: "Error",
        message: l,
        context: context,
        contentType: ContentType.failure,
      ),
      (r) => Navigator.pop(context),
    );

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
                      const Text("Billbook (नामसारी भएको फोटो)"),
                      SizedBox(
                        height: 150,
                        child: displayImage(
                            svgImage: "assets/images/pfp.svg",
                            apiImage: blueBook1API,
                            image: _bluebook1),
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
                          onPressed: getBluebookImage,
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
                      const Text("Billbook (सवारीको विस्तृत विवरण)"),
                      SizedBox(
                        height: 150,
                        child: displayImage(
                            svgImage: "assets/images/pfp.svg",
                            apiImage: blueBook2API,
                            image: _bluebook2),
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
                          onPressed: getBluebookImage2,
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
