import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KilnColors {
  // prevent initialization;
  KilnColors._();

  static const _cyanPrimaryValue = 0xFF30BCED;
  static const cyan = MaterialColor(
    _cyanPrimaryValue,
    <int, Color>{
      50: Color(0xFFE6F7FD),
      100: Color(0xFFC1EBFA),
      200: Color(0xFF98DEF6),
      300: Color(0xFF6ED0F2),
      400: Color(0xFF4FC6F0),
      500: Color(_cyanPrimaryValue),
      600: Color(0xFF2BB6EB),
      700: Color(0xFF24ADE8),
      800: Color(0xFF1EA5E5),
      900: Color(0xFF1397E0),
    },
  );

  static const _jetPrimaryValue = 0xFF303036;
  static const jet = MaterialColor(
    _jetPrimaryValue,
    <int, Color>{
      50: Color(0xFFE6E6E7),
      100: Color(0xFFC1C1C3),
      200: Color(0xFF98989B),
      300: Color(0xFF6E6E72),
      400: Color(0xFF4F4F54),
      500: Color(_jetPrimaryValue),
      600: Color(0xFF2B2B30),
      700: Color(0xFF242429),
      800: Color(0xFF1E1E22),
      900: Color(0xFF131316),
    },
  );

  static const _gainsboroPrimaryValue = 0xFFDBD9E0;
  static const gainsboro = MaterialColor(
    _gainsboroPrimaryValue,
    <int, Color>{
      50: Color(0xFFFBFAFB),
      100: Color(0xFFF4F4F6),
      200: Color(0xFFEDECF0),
      300: Color(0xFFE6E4E9),
      400: Color(0xFFE0DFE5),
      500: Color(_gainsboroPrimaryValue),
      600: Color(0xFFD7D5DC),
      700: Color(0xFFD2CFD8),
      800: Color(0xFFCDCAD3),
      900: Color(0xFFC4C0CB),
    },
  );

  static const _blackPrimaryValue = 0xFF050401;
  static const black = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFFE1E1E1),
      100: Color(0xFFB4B4B3),
      200: Color(0xFF828280),
      300: Color(0xFF504F4D),
      400: Color(0xFF2B2A27),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF040301),
      700: Color(0xFF040301),
      800: Color(0xFF030201),
      900: Color(0xFF010100),
    },
  );

  static const _rhythmPrimaryValue = 0xFF7F7CAF;
  static const rhythm = MaterialColor(
    _rhythmPrimaryValue,
    <int, Color>{
      50: Color(0xFFF0EFF5),
      100: Color(0xFFD9D8E7),
      200: Color(0xFFBFBED7),
      300: Color(0xFFA5A3C7),
      400: Color(0xFF9290BB),
      500: Color(_rhythmPrimaryValue),
      600: Color(0xFF7774A8),
      700: Color(0xFF6C699F),
      800: Color(0xFF625F96),
      900: Color(0xFF4F4C86),
    },
  );

  static const _orangePrimaryValue = 0xFFFC5130;
  static const orange = MaterialColor(
    _orangePrimaryValue,
    <int, Color>{
      50: Color(0xFFFFEAE6),
      100: Color(0xFFFECBC1),
      200: Color(0xFFFEA898),
      300: Color(0xFFFD856E),
      400: Color(0xFFFC6B4F),
      500: Color(_orangePrimaryValue),
      600: Color(0xFFFC4A2B),
      700: Color(0xFFFB4024),
      800: Color(0xFFFB371E),
      900: Color(0xFFFA2713),
    },
  );

  static const _textTheme = TextTheme(
    bodyText2: TextStyle(fontSize: 18),
    button: TextStyle(fontSize: 16),
    headline6: TextStyle(fontSize: 25),
  );

  static final lightTheme = ThemeData(
    fontFamily: GoogleFonts.dosis(fontWeight: FontWeight.w500).fontFamily,
    textTheme: _textTheme,
    primaryColor: KilnColors.cyan,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: KilnColors.cyan,
      primaryVariant: KilnColors.cyan[900]!,
      secondary: KilnColors.rhythm,
      secondaryVariant: KilnColors.rhythm[900]!,
      surface: KilnColors.gainsboro,
      background: KilnColors.gainsboro[50]!,
      error: KilnColors.orange,
      onPrimary: KilnColors.black,
      onSecondary: KilnColors.black,
      onSurface: KilnColors.black,
      onBackground: KilnColors.black,
      onError: KilnColors.black,
    ),
  );

  static final darkTheme = ThemeData(
    fontFamily: GoogleFonts.dosis(fontWeight: FontWeight.w500).fontFamily,
    textTheme: _textTheme,
    colorScheme: lightTheme.colorScheme.copyWith(
      brightness: Brightness.dark,
      surface: KilnColors.jet,
      background: KilnColors.black,
      onPrimary: KilnColors.gainsboro[50]!,
      onSecondary: KilnColors.gainsboro[50]!,
      onSurface: KilnColors.gainsboro[50]!,
      onBackground: KilnColors.gainsboro[50]!,
      onError: KilnColors.gainsboro[50]!,
    ),
  );

}
