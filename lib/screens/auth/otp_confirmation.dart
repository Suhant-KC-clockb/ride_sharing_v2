import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/providers/user_controller.dart';
import 'package:ridesharing/utils/mediaquery.dart';

class OtpConfirmation extends ConsumerStatefulWidget {
  const OtpConfirmation({Key? key}) : super(key: key);

  @override
  OtpConfirmationState createState() => OtpConfirmationState();
}

class OtpConfirmationState extends ConsumerState<OtpConfirmation> {
  String? otp;
  Future<void> _otpButton() async {
    if (otp == null) {
      return;
    }
    ref
        .read(userControllerProvider.notifier)
        .login(otp: otp!)
        .then((value) => value.fold(
                (l) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l),
                      ),
                    ), (r) {
              Navigator.pushNamedAndRemoveUntil(context, r, (route) => false);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            // key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Enter the OTP sent to your mobile number",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                OtpTextField(
                  numberOfFields: 5,
                  showFieldAsBox: true,
                  onSubmit: (String verificationCode) {
                    setState(() {
                      otp = verificationCode;
                    });
                    // context.read<Auth>().setOTPCode(verificationCode);
                  }, // end onSubmit
                ),
                Container(
                  width: getWidth(context) * 0.5,
                  margin: const EdgeInsetsDirectional.symmetric(vertical: 20),
                  child: Hero(
                    tag: "button",
                    child: ElevatedButton(
                      onPressed: _otpButton,
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
