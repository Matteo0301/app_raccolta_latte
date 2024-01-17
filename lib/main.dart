import 'dart:io';

import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/login.dart';
import 'package:app_raccolta_latte/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = DevHttpOverrides();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raccolta latte',
      theme: MyTheme().theme,
      home: const Login(title: 'Raccolta latte'),
    );
  }
}
