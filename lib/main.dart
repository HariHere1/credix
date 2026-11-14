import 'dart:ui';

import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ActivityPointsApp());
}

class ActivityPointsApp extends StatelessWidget {
  const ActivityPointsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CREDIX',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) => Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
              ),
            ),
          ),
          Positioned(
            top: -72,
            right: -72,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 44, sigmaY: 44),
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentSoft,
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: -130,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x2400D06C),
                ),
              ),
            ),
          ),
          if (child != null) child,
        ],
      ),
      home: const LoginScreen(),
    );
  }
}
