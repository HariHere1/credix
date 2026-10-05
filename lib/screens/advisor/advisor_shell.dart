import 'package:flutter/material.dart';
import '../../widgets/screen_header.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'review_queue_tab.dart';
import 'students_tab.dart';
import 'export_tab.dart';
import 'account_tab.dart';

class AdvisorShell extends StatefulWidget {
  const AdvisorShell({super.key});

  @override
  State<AdvisorShell> createState() => _AdvisorShellState();
}

class _AdvisorShellState extends State<AdvisorShell> {
  int _selectedIndex = 0;

  void _refreshQueue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ReviewQueueTab(onQueueChanged: _refreshQueue),
      const StudentsTab(),
      const ExportTab(),
      const AdvisorAccountTab(),
    ];

    ScreenHeader.onProfileTap = () => setState(() => _selectedIndex = 3);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabs),
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
          NavigationDestination(icon: Icon(Icons.rate_review_outlined), selectedIcon: Icon(Icons.rate_review_rounded), label: 'Review Queue'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group_rounded), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.upload_file_outlined), selectedIcon: Icon(Icons.upload_file_rounded), label: 'Export'),
          NavigationDestination(icon: Icon(Icons.manage_accounts_outlined), selectedIcon: Icon(Icons.manage_accounts_rounded), label: 'Account'),
        ],
          ),
        ),
      ),
    );
  }
}
