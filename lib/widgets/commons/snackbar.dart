import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

customSnackBar({
  required String title,
  required String message,
  ContentType? contentType,
  required BuildContext context,
}) {
  contentType ??= ContentType.success;
  final snackbar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackbar);
}

imageErrorSnackbar({
  String? title,
  String? message,
  ContentType? contentType,
  required BuildContext context,
}) {
  contentType ??= ContentType.failure;
  final snackbar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title ?? "Error",
      message: message ?? "Image should be smaller than 5MB",
      contentType: contentType,
    ),
  );
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackbar);
}
