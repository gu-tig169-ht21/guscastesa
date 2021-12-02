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
              fontWeight: FontWeight.normal,
              fontSize: 21,
            )),
        dividerTheme: const DividerThemeData(color: Colors.white),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightGreen,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.lightGreen.withOpacity(0.5);
                  } else {
                    return Colors.lightGreen;
                  }
                }))),
        textButtonTheme: const TextButtonThemeData(style: ButtonStyle()));
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.lightGreen,
      scaffoldBackgroundColor: Colors.grey[900],
      fontFamily: 'Arial',
      canvasColor: Colors.grey[900],
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: Colors.lightGreen,
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black54,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 21,
          )),
      dividerTheme: DividerThemeData(
        color: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.lightGreen,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.lightGreen.withOpacity(0.5);
                } else {
                  return Colors.lightGreen;
                }
              }))),
      cardTheme: const CardTheme(
        color: Colors.black54,
      ),
    );
  }
}
