import 'package:flutter/material.dart';

class ThemeApp {

  static ThemeData getLight() {
    return ThemeData(
      fontFamily: 'TenorSans',
      colorScheme: colorSchemeLight
    );
  }

  static ThemeData getDark() {
    return ThemeData(colorScheme: colorSchemeDark);
  }

  //Esquema de cores
  static final colorSchemeLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: const Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFF5F5DC),
    onSecondary: Color(0xFF1C1C1C),
    surface: Colors.white,
    onSurface: Color(0xFF2E2E2E),
    error: Color.fromARGB(255, 255, 0, 0),
    onError: Colors.white,
  );

  static final colorSchemeDark = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color.fromARGB(255, 255, 255, 255), 
    onPrimary: const Color.fromARGB(255, 0, 0, 0),
    secondary: const Color.fromARGB(255, 255, 255, 255), 
    onSecondary: const Color.fromARGB(255, 0, 0, 0), 
    surface: const Color(0xFF1C1C1C),
    onSurface: const Color.fromARGB(255, 255, 255, 255), 
    error: const Color.fromARGB(255,255,100,100,), 
    onError: const Color.fromARGB(255, 255, 255, 255), 
  );
}
