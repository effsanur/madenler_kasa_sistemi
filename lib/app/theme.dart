import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 241, 210, 72),
      secondary: Color(0xFF03DAC6),
      surface: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFB00020),
      tertiary: Color(0xFF6A6757),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: const Color(0xFF6200EE)),
    ),
  );
}
