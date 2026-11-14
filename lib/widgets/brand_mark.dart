import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({super.key, required this.size});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(size * 0.27),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2200D06C),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.verified_rounded,
          color: AppColors.onAccent,
          size: size * 0.58,
        ),
      );
}
