import 'package:flutter/material.dart';

// Design tokens. Changing values here rethemes the whole app.
abstract final class AppColors {
  static const Color background = Color(0xFFF5F8FA);
  static const Color surface = Color(0xEFFFFFFF);
  static const Color surfaceElevated = Color(0xF2FFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color cardBackground = Color(0xDFFFFFFF);

  // Fine ink-tinted edge used on translucent glass surfaces.
  static const Color border = Color(0x1A111827);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF6B7280);

  static const Color accent = Color(0xFF00D06C);
  static const Color accentLight = Color(0xFF00B35C);
  static const Color accentDark = Color(0xFF00B35C);
  static const Color onAccent = Color(0xFF0A291A);
  static const Color accentSoft = Color(0x1F00D06C);
  static const Color accentContainer = Color(0x1F00D06C);
  // The slider uses the same green in its idle fill and confirmed state.
  static const Color sliderAccent = Color(0xFF00D06C);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = Color(0x14EF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color success = Color(0xFF00D06C);

  static const Color autoApprovedBg = Color(0x1F00D06C);
  static const Color autoApprovedFg = Color(0xFF008A49);
  static const Color flaggedBg = Color(0x14EF4444);
  static const Color flaggedFg = Color(0xFFDC2626);
  static const Color statusReviewedBg = autoApprovedBg;
  static const Color statusReviewedFg = autoApprovedFg;

  // kept names for compatibility
  static const Color groupI = Color(0xFF00D06C);
  static const Color groupII = Color(0xFF3B82F6);
  static const Color groupIII = Color(0xFFF59E0B);
  static const Color statusPendingBg = Color(0x1AF59E0B);
  static const Color statusPendingFg = Color(0xFFB77905);
  static const Color statusAutoApprovedBg = autoApprovedBg;
  static const Color statusAutoApprovedFg = autoApprovedFg;
  static const Color statusFlaggedBg = flaggedBg;
  static const Color statusFlaggedFg = flaggedFg;
  static const Color statusRejectedBg = Color(0x14EF4444);
  static const Color statusRejectedFg = Color(0xFFDC2626);

  static const Color divider = Color(0x14111827);
  static const Color whiteBorder = Color(0xBFFFFFFF);
  static const Color buttonPrimary = Color(0xFF00D06C);
  static const Color onButtonPrimary = Color(0xFF0A291A);
}
