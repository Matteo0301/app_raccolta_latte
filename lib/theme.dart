import 'package:flutter/material.dart';

class MyTheme {
  static const Color mainColor = Color.fromRGBO(22, 44, 243, 1);
  static Map<int, Color> color = {
    50: const Color.fromRGBO(22, 44, 243, .1),
    100: const Color.fromRGBO(22, 44, 243, .2),
    200: const Color.fromRGBO(22, 44, 243, .3),
    300: const Color.fromRGBO(22, 44, 243, .4),
    400: const Color.fromRGBO(22, 44, 243, .5),
    500: const Color.fromRGBO(22, 44, 243, .6),
    600: const Color.fromRGBO(22, 44, 243, .7),
    700: const Color.fromRGBO(22, 44, 243, .8),
    800: const Color.fromRGBO(22, 44, 243, .9),
    900: const Color.fromRGBO(22, 44, 243, 1),
  };
  static MaterialColor colorCustom = MaterialColor(0xFF162CF3, color);
  final theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: colorCustom,
      accentColor: mainColor,
      cardColor: mainColor,
      brightness: Brightness.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: mainColor,
        onPrimary: Colors.white,
        onSurface: Colors.grey,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
  );
}
