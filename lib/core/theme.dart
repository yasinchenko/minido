import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => light;

  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    useMaterial3: true,
    fontFamily: 'Roboto',
  );
}
