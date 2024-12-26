// lib/theme.dart
import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  fontFamily: 'Nunito',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF212121), // Replacing `backgroundColor`
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
  ).copyWith(secondary: Colors.white),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: AppTheme.primaryColor,
    backgroundColor: Colors.white,
  ),
  dividerColor: Colors.black12,
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent, // Updated for the latest Flutter
    centerTitle: true,
    toolbarTextStyle: TextStyle(color: Colors.white),
    iconTheme: IconThemeData(),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'Nunito',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    ),
  ),
);

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.white,
  fontFamily: 'Nunito',
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE5E5E5), // Replacing `backgroundColor`
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
  ).copyWith(secondary: Colors.green),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: Colors.green, // Adjusted to match light theme
  ),
  dividerColor: Colors.white54,
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green), // Adjusted to light theme color
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.green), // Adjusted to light theme color
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent, // Updated for the latest Flutter
    centerTitle: true,
    toolbarTextStyle: TextStyle(color: Colors.green), // Adjusted to light theme color
    iconTheme: IconThemeData(color: Colors.green), // Adjusted to light theme color
    titleTextStyle: TextStyle(
      color: Colors.green, // Adjusted to light theme color
      fontFamily: 'Nunito',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    ),
  ),
);
