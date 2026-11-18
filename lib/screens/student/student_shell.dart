import 'dart:ui';

import 'package:flutter/material.dart';
import '../../widgets/screen_header.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'certificates_tab.dart';
import 'points_tab.dart';
import 'account_tab.dart';
import '../../models/student.dart';

class StudentShell extends StatefulWidget {
  final Student student;
  const StudentShell({super.key, this.student = kMockStudent});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenHeader.onProfileTap = () => setState(() => _selectedIndex = 2);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CertificatesTab(student: widget.student),
          PointsTab(student: widget.student),
          StudentAccountTab(student: widget.student),
        ],
      ),
      bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.bottomBarRadius)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
              ),
              child: NavigationBar(
                height: AppSpacing.bottomNavigationHeight,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (i) => setState(() => _selectedIndex = i),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.desktop_windows_outlined), selectedIcon: Icon(Icons.desktop_windows_rounded), label: 'Certificates'),
                  NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Points'),
                  NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Account'),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
