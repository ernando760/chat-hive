import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Colors.orangeAccent),
    brightness: Brightness.light,
    primaryColor: Colors.orangeAccent,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.orangeAccent,
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white)),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Colors.orangeAccent),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: Colors.orangeAccent,
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent)),
      floatingLabelStyle: const TextStyle(color: Colors.orangeAccent),
      labelStyle: TextStyle(color: Colors.grey[600]),
      iconColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24),
      titleMedium: TextStyle(fontSize: 20),
      titleSmall: TextStyle(fontSize: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: Colors.orangeAccent[700]),
    brightness: Brightness.dark,
    primaryColor: Colors.orangeAccent[700],
    scaffoldBackgroundColor: Colors.grey[900],
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: Colors.orangeAccent[700]),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.orangeAccent[700],
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white)),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: Colors.orangeAccent[700],
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent[700]!)),
      floatingLabelStyle: TextStyle(color: Colors.orangeAccent[700]),
      labelStyle: TextStyle(color: Colors.grey[400]),
      iconColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, color: Colors.white),
      titleMedium: TextStyle(fontSize: 20, color: Colors.white),
      titleSmall: TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
}
