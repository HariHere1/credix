import 'package:flutter/material.dart';
import '../../widgets/screen_header.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'certificates_tab.dart';
import 'points_tab.dart';
import 'account_tab.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

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
        children: const [
          CertificatesTab(),
          PointsTab(),
          StudentAccountTab(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.bottomBarRadius)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
          ),
          child: NavigationBar(
        height: 64,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.workspace_premium_outlined), selectedIcon: Icon(Icons.workspace_premium_rounded), label: 'Certificates'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart_rounded), label: 'Points'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Account'),
        ],
          ),
        ),
      ),
    );
  }
}
