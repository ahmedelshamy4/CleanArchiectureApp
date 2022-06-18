import 'package:clean_app/src/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData appTheme = ThemeData(
    primaryColor: mainClr,
    scaffoldBackgroundColor: whiteClr,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainClr,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: whiteClr,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: mainClr,
    ),
  );
}
