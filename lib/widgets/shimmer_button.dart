import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Button with a light shimmer travelling around its perimeter,
/// replicating Magic UI's "Shimmer Button" in Flutter.
class ShimmerButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color background;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const ShimmerButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.background = AppColors.accent,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  });

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Material(
        color: widget.background,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            children: [
              Padding(padding: widget.padding, child: widget.child),
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: _BorderGlowPainter(
                        progress: _controller.value,
                        color: Colors.white,
                        radius: widget.borderRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a faint full rounded border plus a bright "glow" segment that runs
/// along the perimeter of the rounded rectangle.
class _BorderGlowPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double radius;

  _BorderGlowPainter({
    required this.progress,
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 3.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);

    // Faint base border
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = color.withOpacity(0.18),
    );

    final metric = path.computeMetrics().first;
    final total = metric.length;
    if (total == 0) return;

    final segLength = total * 0.28;
    final start = (progress * total) % total;
    final end = start + segLength;

    Paint glow() => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(0.85);

    if (end <= total) {
      canvas.drawPath(metric.extractPath(start, end), glow());
    } else {
      canvas.drawPath(metric.extractPath(start, total), glow());
      canvas.drawPath(metric.extractPath(0, end - total), glow());
    }
  }

  @override
  bool shouldRepaint(covariant _BorderGlowPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
