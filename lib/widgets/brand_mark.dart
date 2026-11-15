import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({super.key, required this.size});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.27),
        child: Image.asset('assets/brand/credix_logo.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            semanticLabel: 'CREDIX logo'),
      );
}
