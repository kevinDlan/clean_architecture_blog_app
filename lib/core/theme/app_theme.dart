import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _inputBorderStyle(
          [Color color = AppPallete.borderColor]) =>
      OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 3),
          borderRadius: BorderRadius.circular(10));

  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      chipTheme: const ChipThemeData(
          color: MaterialStatePropertyAll(AppPallete.backgroundColor),
          side: BorderSide.none),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          border: _inputBorderStyle(),
          enabledBorder: _inputBorderStyle(),
          focusedBorder: _inputBorderStyle(AppPallete.gradient2),
          errorBorder: _inputBorderStyle(AppPallete.errorColor)),
      appBarTheme:
          const AppBarTheme(backgroundColor: AppPallete.backgroundColor));
}
