import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF080D18);
  static const Color surface = Color(0xFF172131);
  static const Color primary = Color(0xFF65B8FF);
  static const Color amber = Color(0xFFFFC76B);
  static const Color textPrimary = Color(0xFFF4F7FC);
  static const Color textSecondary = Color(0xFF8D9BB0);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: surface,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
    ),
    useMaterial3: true,
  );
}