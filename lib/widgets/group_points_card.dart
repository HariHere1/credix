import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class GroupPointsCard extends StatelessWidget {
  final String groupLabel;
  final int earned;
  final int max;
  final Color color;

  const GroupPointsCard({
    super.key,
    required this.groupLabel,
    required this.earned,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (earned / max).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  groupLabel,
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                ),
                Text(
                  '$earned / $max',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0, end: pct),
                builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 6, color: color, backgroundColor: AppColors.surfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
