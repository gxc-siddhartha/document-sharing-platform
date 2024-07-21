import 'package:document_sharing_app/theme/colors.dart';
import 'package:flutter/material.dart';

class AppThemeStyle {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Inter",
    useMaterial3: false,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppThemeColors.themeColor,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontFamily: "Inter",
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.black.withOpacity(
          0.6,
        ),
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black.withOpacity(
          0.6,
        ),
      ),
      toolbarHeight: 60,
      backgroundColor: Colors.white,
      elevation: 0.4,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        minimumSize: MaterialStatePropertyAll(
          Size(
            double.infinity,
            45,
          ),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                12,
              ),
            ),
          ),
        ),
      ),
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
