import 'package:flutter/material.dart';
import 'dart:math' as math;
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
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(value: animated, primary: primary, secondary: secondary),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(animated * 100).round()}%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'completed',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color primary;
  final Color secondary;

  _GaugePainter({required this.value, required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);

    // 10% white track
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.white12,
    );

    // Foreground arc starting at the top
    canvas.drawArc(
      rect,
      -math.pi / 2,
      value * 2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = primary,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.primary != primary;
}
