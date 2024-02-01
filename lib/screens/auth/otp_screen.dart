import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ridesharing/data/providers/user_controller.dart';
import 'package:ridesharing/routes.dart';
import 'package:ridesharing/utils/mediaquery.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _phoneNumberController.text = "9860137229";
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void onContinuePressed() {
    try {
      ref
          .read(userControllerProvider.notifier)
          .registerPhone(phoneNumber: _phoneNumberController.text)
          .then((value) => value.fold((l) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l),
                  ),
                );
              }, (r) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(r),
                  ),
                );
                Navigator.pushNamed(context, Pathname.otpConfirmation);
              }));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                Image.asset(
                  height: getHeight(context) * 0.5,
                  fit: BoxFit.fill,
                  "assets/images/getting_started.png",
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "We’ll send you one time password in your mobile number",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffD9D9D9),
                      labelText: 'Mobile Number',
                      hintText: 'Enter your mobile number',
                      contentPadding:
                          EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      //returning null is read as correct
                      if (value!.isEmpty) {
                        return 'Please enter a number';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  width: getWidth(context) * 0.5,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Hero(
                    tag: "button",
                    child: ElevatedButton(
                      onPressed: onContinuePressed,
                      child: const Text("Continue"),
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
