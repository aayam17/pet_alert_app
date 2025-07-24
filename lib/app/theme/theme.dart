import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF76C7C0);     
  static const Color secondaryColor = Color(0xFFFFC107);   
  static const Color backgroundColor = Color(0xFFF8F8F8);  
  static const Color textColor = Color(0xFF333333);        

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    fontFamily: 'Poppins Regular',
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins Regular',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'Poppins Regular',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(10),
      color: Colors.white,
    ),
  );

  static var textPrimary;

  static var background;

  static var primary;

  static var error;

  static var textSecondary;

  static var accent;
}
