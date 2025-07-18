import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF232634);
  static const Color cardBackground = Color(0xFF313348);
  static const Color greenGradient = Color(0xFF29C6A5);
  static const Color yellowGradient = Color(0xFFFFF370);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: greenGradient,
      cardColor: cardBackground,
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: greenGradient, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: greenGradient,
          foregroundColor: darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: greenGradient,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(greenGradient),
        checkColor: WidgetStateProperty.all(darkBackground),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: cardBackground,
      ),
    );
  }
  static LinearGradient get mainGradient => const LinearGradient(
    colors: [greenGradient, yellowGradient],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}