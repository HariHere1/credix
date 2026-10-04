import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated circular gauge replicating Magic UI's "Animated Circular Progress Bar".
class CircularProgressGauge extends StatelessWidget {
  final int value; // 0..max
  final int max;
  final double size;
  final Color primary;
  final Color secondary;

  const CircularProgressGauge({
    super.key,
    required this.value,
    this.max = 100,
    this.size = 140,
    this.primary = AppColors.accent,
    this.secondary = AppColors.surfaceVariant,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: pct),
      builder: (context, animated, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: animated,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                backgroundColor: secondary,
                valueColor: AlwaysStoppedAnimation(primary),
              ),
              Text(
                '${(animated * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
