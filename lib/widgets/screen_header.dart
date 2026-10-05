import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Top header used on main tabs: small "ACTIVITY POINTS" eyebrow, a big title,
/// and a notification bell + avatar on the right.
class ScreenHeader extends StatelessWidget {
  final String title;
  final String eyebrow;

  const ScreenHeader({super.key, required this.title, this.eyebrow = 'ACTIVITY POINTS'});

  /// Set by the shell so the avatar opens the Account tab.
  static VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.sm, AppSpacing.pagePadding, 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow.isNotEmpty) ...[
                  Text(
                    eyebrow.toUpperCase(),
                    style: const TextStyle(color: AppColors.textDisabled, fontSize: 9, letterSpacing: 1.3, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications (mock).'))),
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          GestureDetector(
            onTap: () => ScreenHeader.onProfileTap?.call(),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.accentContainer,
              child: const Icon(Icons.person_rounded, size: 17, color: AppColors.accentLight),
            ),
          ),
        ],
      ),
    );
  }
}
