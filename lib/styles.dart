// lib/styles.dart
import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle elevatedButtonStyle = ButtonStyle(
    backgroundColor:
        WidgetStateProperty.all(const Color.fromARGB(255, 33, 240, 243)),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 18),
    ),
  );
  static final ButtonStyle elevatedButtonStylehome = ButtonStyle(
    backgroundColor:
        WidgetStateProperty.all(const Color.fromARGB(255, 33, 240, 243)),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 255, 152, 0), // Change text color to black
      ),
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
    ),
  );

  static final ButtonStyle textButtonStyle = ButtonStyle(
    textStyle: WidgetStateProperty.all(
      const TextStyle(color: Color.fromARGB(255, 226, 11, 11)),
    ),
  );
}
