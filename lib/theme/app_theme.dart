import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color secondaryColor = Color(0xFF2A2A2A);
  static const Color accentColor = Color(0xFF3A3A3A);
  static const Color textColor = Colors.white;
  static const Color hintColor = Color(0xFF808080);
  static const Color success = Color(0xFFB3B3B3);
  static const Color grey600 = Color(0xFF85858A);
  static const Color background = Color(0xFF121212);

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'CircularStd',
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: primaryColor,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: secondaryColor,
      onPrimary: textColor,
      onSecondary: textColor,
      onSurface: textColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      titleMedium: TextStyle(color: hintColor),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      side: const BorderSide(
        color: Color(0xFFB3B3B3),
        width: 2,
      ),
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          // return Colors.white;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all<Color>(Color(0xFFB3B3B3)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black, 
      hintStyle: const TextStyle(color: hintColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      labelStyle: const TextStyle(color: Colors.white60),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF414141),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          width: 1.5,
          color: Color(0xFF414141),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF414141),
        ),
      ),
      suffixIconColor: Colors.white70,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3C424C),
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    ),
  );
} 