import 'package:flutter/material.dart';

class AppColors {
  static final Color primaryColor = Color.fromRGBO(14, 47, 79, 1.0);
  static final Color secondaryColor = Color.fromRGBO(248, 189, 13, 1.0);

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
