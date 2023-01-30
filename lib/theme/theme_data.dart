import 'package:flutter/material.dart';
import 'package:flutter_maps/theme/theme.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: AppColors.white,
      textTheme: const TextTheme(
        headline3: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        headline4: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        headline5: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          fontSize: 16,
        ),
        headline6: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
