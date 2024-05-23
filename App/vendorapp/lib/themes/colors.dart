import 'package:flutter/material.dart';

class AppColors {
  static final Color primaryColor = Color.fromRGBO(230, 93, 30, 1.0);
  static final Color secondaryColor = Color.fromRGBO(119, 46, 12, 1.0);

  // static final Color backgroundColor = Color(0xFFC7B4FF);
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    // Other light mode theme properties
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    brightness: Brightness.dark,
    // Other dark mode theme properties
  );
}
