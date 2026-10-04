import 'package:flutter/material.dart';
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

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.rate_review_outlined), selectedIcon: Icon(Icons.rate_review_rounded), label: 'Review Queue'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group_rounded), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.upload_file_outlined), selectedIcon: Icon(Icons.upload_file_rounded), label: 'Export'),
          NavigationDestination(icon: Icon(Icons.manage_accounts_outlined), selectedIcon: Icon(Icons.manage_accounts_rounded), label: 'Account'),
        ],
      ),
    );
  }
}
