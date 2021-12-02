import 'package:flutter/material.dart';

//global Themedata för hela appen
class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.lightGreen,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightGreen,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightGreen,
        ),
        textButtonTheme: const TextButtonThemeData(style: ButtonStyle()));
  }
}
