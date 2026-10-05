import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Reveals its [child] with a subtle fade + rise, staggered per index.
class AnimatedListItem extends StatelessWidget {
  final int index;
  final Duration stagger;
  final Widget child;

  const AnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.stagger = const Duration(milliseconds: 60),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: stagger * index)
        .fade(duration: 300.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.08, duration: 300.ms, curve: Curves.easeOutCubic);
  }
}
