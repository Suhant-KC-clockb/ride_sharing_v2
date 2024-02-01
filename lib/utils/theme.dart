import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  inputDecorationTheme:
      InputDecorationTheme(border: const OutlineInputBorder()),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
);
