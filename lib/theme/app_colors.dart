import 'package:flutter/material.dart';

// Design tokens. Changing values here rethemes the whole app.
abstract final class AppColors {
  static const Color background = Color(0xFF090909);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceElevated = Color(0xFF1B1B1B);
  static const Color surfaceVariant = Color(0xFF1B1B1B);
  static const Color cardBackground = Color(0xFF131313);

  // White tinted border (white at 8%)
  static const Color border = Color(0x14FFFFFF);

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color textDisabled = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF6B6B6B);

  static const Color accent = Color(0xFFFFFFFF);
  static const Color accentLight = Color(0xFFE5E5E5);
  static const Color accentDark = Color(0xFFE5E5E5);
  static const Color onAccent = Color(0xFF000000);
  static const Color accentSoft = Color(0x24FFFFFF);
  static const Color accentContainer = Color(0xFF1B1B1B);

  // Status is communicated through contrast and copy rather than hue.
  static const Color danger = Color(0xFFF5F5F5);
  static const Color dangerSoft = Color(0x14FFFFFF);
  static const Color warning = Color(0xFFB8B8B8);
  static const Color error = Color(0xFFF5F5F5);
  static const Color info = Color(0xFFFFFFFF);
  static const Color success = Color(0xFFFFFFFF);

  static const Color autoApprovedBg = Color(0x24FFFFFF);
  static const Color autoApprovedFg = Color(0xFFFFFFFF);
  static const Color flaggedBg = Color(0xFF1B1B1B);
  static const Color flaggedFg = Color(0xFFF5F5F5);
  static const Color statusReviewedBg = Color(0xFF1B1B1B);
  static const Color statusReviewedFg = Color(0xFFFFFFFF);

  // kept names for compatibility
  static const Color groupI = Color(0xFFFFFFFF);
  static const Color groupII = Color(0xFFE5E5E5);
  static const Color groupIII = Color(0xFF9A9A9A);
  static const Color statusPendingBg = Color(0xFF1B1B1B);
  static const Color statusPendingFg = Color(0xFF9A9AA3);
  static const Color statusAutoApprovedBg = Color(0x24FFFFFF);
  static const Color statusAutoApprovedFg = Color(0xFFFFFFFF);
  static const Color statusFlaggedBg = Color(0xFF1B1B1B);
  static const Color statusFlaggedFg = Color(0xFFF5F5F5);
  static const Color statusRejectedBg = Color(0xFF1B1B1B);
  static const Color statusRejectedFg = Color(0xFFF5F5F5);

  static const Color divider = Color(0x14FFFFFF);
  static const Color whiteBorder = Color(0x14FFFFFF);
  static const Color buttonPrimary = Color(0xFFFFFFFF);
  static const Color onButtonPrimary = Color(0xFF000000);
}
