import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/api.dart';
import 'package:ridesharing/constant/constant.dart';
import 'package:ridesharing/data/models/rider_docs.dart';
import 'package:ridesharing/data/providers/rider_controller.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/commons/gap.dart';
import 'package:ridesharing/widgets/commons/loading_spinner.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ridesharing/widgets/commons/snackbar.dart';

class VehicleInfo extends ConsumerStatefulWidget {
  const VehicleInfo({Key? key}) : super(key: key);

  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends ConsumerState<VehicleInfo> {
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _transportNumber = TextEditingController();
  final TextEditingController _numberPlate = TextEditingController();

  final _form = GlobalKey<FormState>();
  String? imageFromAPI;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select image lesser than 5 MB"),
        ),
      );
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
                          child: (_vehiclePhoto != null)
                              ? Image.file(
                                  File(_vehiclePhoto!.path),
                                )
                              : (imageFromAPI == null)
                                  ? SvgPicture.asset('assets/images/pfp.svg',
                                      semanticsLabel: 'Acme Logo')
                                  : Image.network('$baseUrl/${imageFromAPI}'),
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
                            child: Text("Add Photo"))
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
                          ? Text("Next")
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
