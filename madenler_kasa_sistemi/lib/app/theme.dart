import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  static ThemeData get lightTheme => ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6200EE),
      secondary: Color(0xFF03DAC6),
      surface: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFB00020),
      tertiary: Color(0xFF018786),
    ),
  );
}

final nesne = AppTheme();
