import 'package:flutter/material.dart';

class MyTheme {
  static const Color mainColor = Colors.blue;
  static const Map<int, Color> color = {
    50: Colors.blue,
  };
  final theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      accentColor: mainColor,
      cardColor: mainColor,
      brightness: Brightness.dark,
    ),
  );
}
