import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/section_header.dart';
import '../../widgets/info_row.dart';
import '../auth/login_screen.dart';

class StudentAccountTab extends StatelessWidget {
  const StudentAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = kMockStudent;
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
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
                    InfoRow(label: 'Name', value: s.name),
                    InfoRow(label: 'Roll Number', value: s.rollNo),
                    InfoRow(label: 'Email', value: s.email),
                    InfoRow(label: 'Batch', value: s.batch),
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
