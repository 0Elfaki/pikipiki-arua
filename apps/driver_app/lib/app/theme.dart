import 'package:flutter/material.dart';

class DriverAppTheme {
  // High-contrast outdoor colors for sunlight visibility
  static const Color primaryAmber = Color(0xFFFFB300);
  static const Color primaryDark = Color(0xFF101418);
  static const Color surfaceDark = Color(0xFF1B2228);
  static const Color cardDark = Color(0xFF222B34);
  static const Color accentGreen = Color(0xFF00E676); // Online / Accept
  static const Color accentRed = Color(0xFFFF5252);   // Offline / Reject
  static const Color textLight = Color(0xFFF0F4F8);
  static const Color textMuted = Color(0xFF90A4AE);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryAmber,
        secondary: accentGreen,
        surface: surfaceDark,
      ),
      scaffoldBackgroundColor: primaryDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAmber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
