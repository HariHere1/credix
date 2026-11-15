import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'brand_mark.dart';

/// Compact brand bar shared by the app's main tabs.
class ScreenHeader extends StatelessWidget {
  final String title;
  final String eyebrow;

  const ScreenHeader({super.key, required this.title, this.eyebrow = 'CREDIX'});

  /// Set by the shell so the avatar opens the Account tab.
  static VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.sm),
      child: Row(
        children: [
          const BrandMark(size: 36),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CREDIX', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, height: 1.1, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                const SizedBox(height: 2),
                Text(title.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.1, letterSpacing: 0.8, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications (mock).'))),
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 23),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          InkWell(
            onTap: () => ScreenHeader.onProfileTap?.call(),
            customBorder: const CircleBorder(),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF007A45),
              child: Icon(Icons.person_rounded, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
