import 'package:flutter/material.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: MediaQuery.of(context).platformBrightness == Brightness.light
        ? lightColorScheme
        : darkColorScheme,
  );
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: claret,
  onPrimary: veryLightGrey,
  secondary: pink,
  onSecondary: darkGrey,
  surface: lavender,
  surfaceContainerHighest: pearl,
  onSurface: darkGrey,
  onSurfaceVariant: sepia,
  error: Colors.red,
  onError: Colors.white,
  surfaceContainerLow: whiteSmoke,
  surfaceContainerLowest: white,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: darkClaret,
  onPrimary: veryLightGrey,
  secondary: darkPink,
  onSecondary: softDarkGrey,
  surface: darkLavender,
  surfaceContainerHighest: darkPearl,
  onSurface: veryLightGrey,
  onSurfaceVariant: lightSepia,
  error: Colors.red,
  onError: Colors.black,
  surfaceContainerLow: nightRider,
  surfaceContainerLowest: veryDarkGrey,
);

// Light theme colors
const Color claret = Color(0xFF641C34);
const Color pink = Color(0xFFE8CFD6);
const Color pearl = Color(0xFFE5DBDE);
const Color lavender = Color(0xFFF7F2F5);
const Color whiteSmoke = Color(0xFFF5F0F0);
const Color veryLightGrey = Color(0xFFFAF7FA);
const Color darkGrey = Color(0xFF333333);
const Color white = Color(0xFFFFFFFF);
const Color sepia = Color(0xFF9C5C4A);

// Dark theme colors
const Color darkClaret = Color(0xFF3B0F21);
const Color darkPink = Color(0xFFE4AFBB);
const Color darkPearl = Color(0xFF908384);
const Color darkLavender = Color(0xFF3E343A);
const Color nightRider = Color(0xFF2E2828);
const Color veryDarkGrey = Color(0xFF1E1E1E);
const Color lightSepia = Color(0xFFF8B493);
const Color softDarkGrey = Color(0xFF5F5E5E);

