import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_header.dart';
import '../auth/login_screen.dart';

class AdvisorAccountTab extends StatelessWidget {
  const AdvisorAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final a = kMockAdvisor;

    return Scaffold(
      appBar: AppBar(title: const Text('Advisor Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Profile'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    InfoRow(label: 'Name', value: a.name),
                    InfoRow(label: 'Email', value: a.email),
                    InfoRow(label: 'Department', value: a.department),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Session'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    ),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    child: const Text('Logout'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
