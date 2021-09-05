import 'package:flutter/material.dart';

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

  static const _magnoliaPrimaryValue = 0xFFFFFAFF;
  static const magnolia = MaterialColor(
    _magnoliaPrimaryValue,
    <int, Color>{
      100: Color(0xFFFFFEFF),
      300: Color(0xFFFFFCFF),
      500: Color(_magnoliaPrimaryValue),
      700: Color(0xFFFFF9FF),
      900: Color(0xFFFFF6FF),
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

}
