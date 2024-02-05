import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridesharing/constant/api.dart';

Widget displayImage(
    {String? apiImage,
    XFile? image,
    required String svgImage,
    String? svgSemanticLabel}) {
  return (image != null)
      ? Image.file(
          File(image.path),
        )
      : (apiImage == null)
          ? SvgPicture.asset(svgImage,
              semanticsLabel: svgSemanticLabel ?? "Test")
          : Image.network('$baseUrl/$apiImage');
}
