import 'package:document_sharing_app/theme/colors.dart';
import 'package:flutter/material.dart';

class AppThemeStyle {
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Inter",
    useMaterial3: false,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppThemeColors.themeColor,
    ),
  );
}

class LightThemeTextStyles {
  static const kButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const kTitleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static const kBodyTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const kBodyTextStyleBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const kSmallBodyTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle kBodyTextStyleCC(Color color) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

  static TextStyle kBodyTextStyleBoldCC(Color color) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }
}
