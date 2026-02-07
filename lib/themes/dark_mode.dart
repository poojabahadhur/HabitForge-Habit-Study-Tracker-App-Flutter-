import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF071010),
  primaryColor: const Color(0xFF0E9AA7),
  colorScheme: ColorScheme.dark(
    background: const Color(0xFF071010),
    primary: const Color(0xFF0E9AA7),
    secondary: const Color(0xFF1E7C7C),
    tertiary: const Color(0xFF0B2A2A),
    inversePrimary: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF071717),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0E9AA7),
    foregroundColor: Colors.white,
  ),
);
