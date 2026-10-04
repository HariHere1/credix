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
    final animation = AlignmentTween(
      begin: const Alignment(-1.6, 0),
      end: const Alignment(1.6, 0),
    ).animate(_controller);

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
                    animation: animation,
                    builder: (context, _) => Align(
                      alignment: animation.value,
                      child: Container(
                        width: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.white38, Colors.transparent],
                          stops: [0.0, 0.5, 1.0],
                          ),
                        ),
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
