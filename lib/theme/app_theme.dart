import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF5E44FF); // Deep Violet
  static const Color accentColor = Color(0xFFFF8A65); // Peach Accent
  
  // Backgrounds
  static const Color bgLight = Color(0xFFF8F9FA); // Very light grey
  static const Color bgDark = Color(0xFF121212);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1F1F39);
  static const Color textSecondaryLight = Color(0xFF858597);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE5D9FF), Color(0xFFFDE4E4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF6C5DD3), Color(0xFF5E44FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardLight,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryLight),
        bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 16, color: textPrimaryLight),
        bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 14, color: textSecondaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryLight),
        titleTextStyle: TextStyle(
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0, // Flat design with custom shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardDark,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 16, color: Colors.white),
        bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey.shade400),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
