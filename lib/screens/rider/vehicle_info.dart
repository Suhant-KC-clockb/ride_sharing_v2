import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/constant.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/commons/gap.dart';
import 'package:ridesharing/widgets/commons/loading_spinner.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ridesharing/widgets/commons/snackbar.dart';
import 'package:ridesharing/widgets/display_image.dart';

enum RideType { car, bike }

class VehicleInfo extends ConsumerStatefulWidget {
  const VehicleInfo({Key? key}) : super(key: key);

  @override
  VehicleInfoState createState() => VehicleInfoState();
}

class VehicleInfoState extends ConsumerState<VehicleInfo> {
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _transportNumber = TextEditingController();
  final TextEditingController _numberPlate = TextEditingController();
  final TextEditingController _manufacure = TextEditingController();

  final _form = GlobalKey<FormState>();
  String? imageFromAPI;
  RideType rideType = RideType.car;

  final ImagePicker _picker = ImagePicker();

  XFile? _vehiclePhoto;
  bool vehiclePhotoError = false;

  bool loading = false;

  Future<dynamic> getData() async {
    final response =
        await ref.read(riderController.notifier).fetchRiderDetail();

    response.fold((l) => null, (r) {
      setState(() {
        _licenseNumber.text = r.licenseNumber ?? "";
        _transportNumber.text = r.transportName ?? '';
        _numberPlate.text = r.numberPlate ?? '';
        _manufacure.text = r.transportModel ?? '';
        rideType = r.rideType == "car" ? RideType.car : RideType.bike;
        if (r.transportImg != null) {
          imageFromAPI = r.transportImgUrl;
        }
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _licenseNumber.dispose();
    _transportNumber.dispose();
    _numberPlate.dispose();
    _manufacure.dispose();
    super.dispose();
  }

  void submitButton() async {
    final validate = _form.currentState!.validate();

    if (_vehiclePhoto == null && imageFromAPI == null) {
      customSnackBar(
          title: "Please select an image",
          message: "Image must be smaller than 5MB",
          context: context,
          contentType: ContentType.failure);
      return;
    }

    if (!validate) {
      return;
    }
    setState(() {
      loading = true;
    });

    final response =
        await ref.read(riderController.notifier).postRiderVehicleDetail(
              licenseNumber: _licenseNumber.text,
              bikeDetail: _transportNumber.text,
              numberPlate: _numberPlate.text,
              vehiclePhoto:
                  _vehiclePhoto != null ? File(_vehiclePhoto!.path) : null,
              manufacturer: _manufacure.text,
              rideType: rideType,
            );
    response.fold(
        (l) => customSnackBar(
            title: "Error",
            message: l,
            context: context,
            contentType: ContentType.failure), (r) {
      customSnackBar(
          title: "Form updated",
          message: "Please fill the next form",
          context: context);
      Navigator.pushReplacementNamed(context, Pathname.riderLicenseInformation);
    });

    setState(() {
      loading = false;
    });
  }

  Future getFrontImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    var imagePath = await image!.readAsBytes();

    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      setState(() {
        _vehiclePhoto = image;
        imageFromAPI = null;
        vehiclePhotoError = false;
      });
    } else {
      setState(() {
        vehiclePhotoError = true;
      });
      if (!mounted) return;
      imageErrorSnackbar(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Information"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Select your vehicle type ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
                gap10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      hoverColor: Colors.transparent,
                      onTap: () => setState(() {
                        rideType = RideType.car;
                      }),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: rideType == RideType.car
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              color: rideType == RideType.car
                                  ? Theme.of(context).colorScheme.background
                                  : Colors.black,
                              CupertinoIcons.car_detailed,
                              size: 30,
                            ),
                            Text(
                              "Car",
                              style: TextStyle(
                                color: rideType == RideType.car
                                    ? Theme.of(context).colorScheme.background
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      hoverColor: Colors.transparent,
                      onTap: () => setState(() {
                        rideType = RideType.bike;
                      }),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: rideType == RideType.bike
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              color: rideType == RideType.bike
                                  ? Theme.of(context).colorScheme.background
                                  : Colors.black,
                              Icons.motorcycle_sharp,
                              size: 30,
                            ),
                            Text(
                              "Bike",
                              style: TextStyle(
                                color: rideType == RideType.bike
                                    ? Theme.of(context).colorScheme.background
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                gap20(),
                RichText(
                  text: TextSpan(
                    text: 'License Number ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
                gap10(),
                TextFormField(
                  controller: _licenseNumber,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'License Number',
                    hintText: 'Enter your License Number',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    //returning null is read as correct
                    if (value!.isEmpty) {
                      return 'Please enter your liscense number';
                    }

                    return null;
                  },
                ),
                gap20(),
                RichText(
                  text: TextSpan(
                    text: 'Manufacturer ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
                gap10(),
                TextFormField(
                  controller: _manufacure,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Manufacturer',
                    hintText: 'EG: Bajaj',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    //returning null is read as correct
                    if (value!.isEmpty) {
                      return 'Please enter your manufacturer name';
                    }

                    return null;
                  },
                ),
                gap20(),
                RichText(
                  text: TextSpan(
                    text: 'Bike Detail ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
                gap10(),
                TextFormField(
                  controller: _transportNumber,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Bike Detail',
                    hintText: 'EG: Apache RTR 160 4v ABS FI',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    //returning null is read as correct
                    if (value!.isEmpty) {
                      return 'Please enter your bike detail';
                    }

                    return null;
                  },
                ),
                gap20(),
                RichText(
                  text: TextSpan(
                    text: 'Number Plate',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
                gap10(),
                TextFormField(
                  controller: _numberPlate,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Number Plate',
                    hintText: 'EG: BA 139 PA 4341',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    //returning null is read as correct
                    if (value!.isEmpty) {
                      return 'Please enter your number plate';
                    }

                    return null;
                  },
                ),
                gap20(),
                RichText(
                  text: TextSpan(
                    text: 'Vehicle Photo',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
                gap20(),
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
                        const Text("Photo of your vehicle"),
                        SizedBox(
                          height: 150,
                          child: displayImage(
                              svgImage: "assets/images/pfp.svg",
                              apiImage: imageFromAPI,
                              image: _vehiclePhoto),
                          // child: (_vehiclePhoto != null)
                          //     ? Image.file(
                          //         File(_vehiclePhoto!.path),
                          //       )
                          //     : (imageFromAPI == null)
                          //         ? SvgPicture.asset('assets/images/pfp.svg',
                          //             semanticsLabel: 'Acme Logo')
                          //         : Image.network('$baseUrl/${imageFromAPI}'),
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
                gap20(),
                Center(
                  child: SizedBox(
                    width: getWidth(context) * 0.7,
                    child: ElevatedButton(
                      onPressed: !loading ? submitButton : null,
                      child: !loading
                          ? const Text("Next")
                          // buttonLoading()
                          : SizedBox(
                              child: Center(child: buttonLoading()),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
