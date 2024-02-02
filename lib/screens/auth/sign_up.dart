import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/constant.dart';
import 'package:ridesharing/data/providers/user_controller.dart';
import 'package:ridesharing/utils/mediaquery.dart';
import 'package:ridesharing/widgets/commons/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  //Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _termsAndConditionsController =
      TextEditingController();

  String gender = "male";
  String userType = "user";
  bool isChecked = false;
  bool imageError = false;

  //Form Key
  final _form = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _imageUrlController.dispose();
    _termsAndConditionsController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    var imagePath = await image!.readAsBytes();

    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      setState(() {
        _image = image;
        imageError = false;
      });
    } else {
      setState(() {
        imageError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select image lesser than 5 MB"),
        ),
      );
    }
  }

  Future<void> _registerMethod() async {
    if (_image == null) {
      return;
    }

    ref
        .read(userControllerProvider.notifier)
        .registerUser(
            _nameController.text, gender, userType, File(_image!.path))
        .then(
          (value) => value.fold(
              (l) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${l.key}: ${l.description}"),
                    ),
                  ),
              (r) => print(r)
              // Navigator.pushNamedAndRemoveUntil(context, r, (route) => false),
              ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final register = ref.read(userControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                gap10(),
                Center(
                  child: SizedBox(
                    height: 200,
                    child: ClipPath(
                      clipper: const ShapeBorderClipper(
                        shape: CircleBorder(),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: (_image != null)
                          ? InkWell(
                              onTap: getImage,
                              child: Image.file(
                                File(_image!.path),
                              ),
                            )
                          : InkWell(
                              onTap: getImage,
                              child: SvgPicture.asset('assets/images/pfp.svg',
                                  semanticsLabel: 'Acme Logo'),
                            ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageError
                        ? Text(
                            "Image should be smaller than 5 MB",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          )
                        : const SizedBox(),
                  ],
                ),
                gap10(),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    label: Text("Full Name"),
                    hintText: "Enter your full name",
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    //returning null is read as correct
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                gap20(),
                gap20(),
                const Text(
                  "Select your gender",
                  style: TextStyle(fontSize: 18),
                ),
                gap10(),
                SizedBox(
                  width: getWidth(context),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text("Male"),
                        value: "male",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text("Female"),
                        value: "female",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text("Other"),
                        value: "other",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      )
                    ],
                  ),
                ),
                gap10(),
                const Text(
                  "What type of user are you?",
                  style: TextStyle(fontSize: 18),
                ),
                gap10(),
                SizedBox(
                  width: getWidth(context),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text("User"),
                        value: "user",
                        groupValue: userType,
                        onChanged: (value) {
                          setState(() {
                            userType = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text("Rider"),
                        value: "rider",
                        groupValue: userType,
                        onChanged: (value) {
                          setState(() {
                            userType = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'I accept the ',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: getWidth(context) * 0.5,
                    child: ElevatedButton(
                      onPressed: isChecked
                          ? () {
                              if (_image == null) {
                                return;
                              }
                              register
                                  .registerUser(
                                    _nameController.text,
                                    gender,
                                    userType,
                                    File(_image!.path),
                                  )
                                  .then(
                                    (value) => value.fold(
                                      (l) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${l.key}: ${l.description}"),
                                        ),
                                      ),
                                      (r) => Navigator.pushNamedAndRemoveUntil(
                                          context, r, (route) => false),
                                    ),
                                  );
                            }
                          : null,
                      child: const Text("Sign up"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
