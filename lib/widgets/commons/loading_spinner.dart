import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget pageLoading({required BuildContext context}) {
  return SpinKitFadingCube(
    color: Theme.of(context).colorScheme.primary,
    size: 30.0,
  );
}

Widget buttonLoading() {
  return const SpinKitThreeBounce(
    color: Colors.white,
    size: 15.0,
  );
}
