import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    fillColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF0473EA),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff30A00E))
  // ,

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff30A00E),
    onPrimary: Color(0xff30A00E),
    secondary: Color(0xff0473EA),
    onSecondary: Color(0xff0473EA),
    error: Colors.red,
    onError: Colors.red,
    background: Colors.white,
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.black,
  ),
);
