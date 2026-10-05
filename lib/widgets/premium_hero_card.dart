import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shared dark hero card for totals and progress summaries.
class PremiumHeroCard extends StatelessWidget {
  final String eyebrow;
  final Widget value;
  final String subtitle;
  final Widget? trailing;

  const PremiumHeroCard({
    super.key,
    required this.eyebrow,
    required this.value,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md + 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: const TextStyle(color: AppColors.accentLight, fontSize: 10, letterSpacing: 1.6, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  value,
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            if (trailing != null)
              trailing!,
          ],
        ),
      ),
    );
  }
}
