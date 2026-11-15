import 'package:flutter/material.dart';

abstract final class AdminColors {
  static const canvas = Color(0xFFF5F8F9);
  static const ink = Color(0xFF202426);
  static const muted = Color(0xFF68736C);
  static const green = Color(0xFF00C86B);
  static const greenDark = Color(0xFF006E3B);
  static const border = Color(0xFFE8ECEE);
  static const panel = Colors.white;
  static const red = Color(0xFFCE2025);
  static const amber = Color(0xFFB77705);
  static const slate = Color(0xFF59647C);
}

ThemeData buildAdminTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AdminColors.canvas,
    colorScheme: const ColorScheme.light(
      primary: AdminColors.greenDark,
      onPrimary: Colors.white,
      surface: AdminColors.panel,
      onSurface: AdminColors.ink,
      error: AdminColors.red,
    ),
    textTheme: base.textTheme.apply(
      fontFamily: 'DMSans',
      bodyColor: AdminColors.ink,
      displayColor: AdminColors.ink,
    ),
    cardTheme: CardThemeData(
      color: AdminColors.panel,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AdminColors.border),
      ),
    ),
  );
}
