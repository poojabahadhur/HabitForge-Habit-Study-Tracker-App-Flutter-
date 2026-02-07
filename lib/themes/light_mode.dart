import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF6FBFB),
  primaryColor: const Color(0xFF0E9AA7),
  colorScheme: ColorScheme.light(
    background: const Color(0xFFF6FBFB),
    primary: const Color(0xFF0E9AA7),
    secondary: const Color(0xFF79C8C8),
    tertiary: Colors.white,
    inversePrimary: const Color(0xFF234E52),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Color(0xFF234E52),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0E9AA7),
    foregroundColor: Colors.white,
  ),
);
