import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF12324A),
      secondary: Color(0xFF1E5878),
      onSecondary: Colors.white,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.black12,
    shadowColor: Colors.black,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF12324A),
      secondary: Color(0xFF1E5878),
      onSecondary: Colors.white,
    ),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.white24,
    shadowColor: Colors.black,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}