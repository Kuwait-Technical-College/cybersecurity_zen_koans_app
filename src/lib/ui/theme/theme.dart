import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

ThemeData zenLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: saffronOrange,
      onPrimary: lotusWhite,
      primaryContainer: saffronLight,
      onPrimaryContainer: deepMaroon,
      secondary: peacefulTeal,
      onSecondary: lotusWhite,
      secondaryContainer: tealLight,
      onSecondaryContainer: meditationBlue,
      tertiary: zenGold,
      onTertiary: deepMaroon,
      surface: lotusWhite,
      onSurface: wisdomPurple,
    ),
    scaffoldBackgroundColor: lotusWhite,
    textTheme: GoogleFonts.notoSansTextTheme(),
    useMaterial3: true,
  );
}

ThemeData zenDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: saffronDark,
      onPrimary: lotusWhite,
      primaryContainer: deepMaroon,
      onPrimaryContainer: lotusWhite,
      secondary: tealDark,
      onSecondary: lotusWhite,
      secondaryContainer: meditationBlue,
      onSecondaryContainer: lotusWhite,
      tertiary: goldDark,
      onTertiary: meditationBlue,
      surface: purpleDark,
      onSurface: lotusWhite,
    ),
    scaffoldBackgroundColor: meditationBlue,
    textTheme: GoogleFonts.notoSansTextTheme(
      ThemeData.dark().textTheme,
    ),
    useMaterial3: true,
  );
}
