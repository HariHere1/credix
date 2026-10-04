import 'package:flutter/material.dart';

/// All brand colors live here. Changing this file is sufficient to retheme the
/// entire app — no other file references raw color literals.
abstract final class AppColors {
  // Backgrounds / surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F7FB);
  static const Color surfaceVariant = Color(0xFFEEF2F8);
  static const Color cardBackground = Color(0xFFF5F7FB);

  // Accent (blue)
  static const Color accent = Color(0xFF2F6BFF);
  static const Color accentLight = Color(0xFF5A86FF);
  static const Color accentDark = Color(0xFF1F4FD1);
  static const Color accentContainer = Color(0xFFE3ECFF);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // Status chips (light tints)
  static const Color statusPendingBg = Color(0xFFEEF2F8);
  static const Color statusPendingFg = Color(0xFF6B7280);

  static const Color statusAutoApprovedBg = Color(0xFFE3ECFF);
  static const Color statusAutoApprovedFg = Color(0xFF2F6BFF);

  static const Color statusFlaggedBg = Color(0xFFFDE8E8);
  static const Color statusFlaggedFg = Color(0xFFD32F2F);

  static const Color statusReviewedBg = Color(0xFFE3ECFF);
  static const Color statusReviewedFg = Color(0xFF2F6BFF);

  static const Color statusRejectedBg = Color(0xFFFDE8E8);
  static const Color statusRejectedFg = Color(0xFFD32F2F);

  // Dividers / borders
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE1E6EF);

  // Misc
  static const Color success = Color(0xFF2F6BFF);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF2F6BFF);

  // Group colors (blues/grays)
  static const Color groupI = Color(0xFF2F6BFF);
  static const Color groupII = Color(0xFF5A86FF);
  static const Color groupIII = Color(0xFF9AB4FF);
}
