import 'package:flutter/material.dart';

class HelperFunctions {
  static void showCustomSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
        ),
      ),
    );
  }
}
