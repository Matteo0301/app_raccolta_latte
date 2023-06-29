import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/login.dart';
import 'package:app_raccolta_latte/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raccolta latte',
      theme: MyTheme().theme,
      home: const Login(title: 'Raccolta latte'),
    );
  }
}
