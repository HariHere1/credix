import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/section_header.dart';
import '../../widgets/info_row.dart';
import '../../widgets/faq_tile.dart';
import '../../widgets/screen_header.dart';
import '../auth/login_screen.dart';

class AdvisorAccountTab extends StatelessWidget {
  const AdvisorAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final a = kMockAdvisor;
    final flagged = getFlaggedCertificates().length;
    final reviewed = kMockCertificates
        .where((c) => c.status == CertificateStatus.reviewed)
        .length;
    final students = kMockStudents.length;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding,
            AppSpacing.sm, AppSpacing.pagePadding, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(
                title: 'Account', eyebrow: 'ADVISOR / ACTIVITY POINTS'),
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.accentSoft,
                  child: Text(
                    a.name
                        .replaceAll('Dr. ', '')
                        .split(' ')
                        .map((e) => e[0])
                        .take(2)
                        .join(),
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.name,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(a.email,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: _stat(flagged, 'In queue')),
                const SizedBox(width: AppSpacing.cardGap),
                Expanded(child: _stat(reviewed, 'Reviewed')),
                const SizedBox(width: AppSpacing.cardGap),
                Expanded(child: _stat(students, 'Students')),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Profile'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    InfoRow(label: 'Department', value: a.department),
                    Divider(color: AppColors.divider),
                    InfoRow(label: 'Role', value: 'Faculty Advisor'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Settings'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Column(
                children: [
                  _row(context, Icons.lock_outline, 'Change password'),
                  Divider(color: AppColors.divider, height: 1),
                  _row(context, Icons.help_outline, 'Help'),
                  Divider(color: AppColors.divider, height: 1),
                  _row(context, Icons.info_outline, 'App version 1.0.0'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              ),
              child: const Text('Logout',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: AppSpacing.xl),
            const FaqSection(),
          ],
        ),
      ),
    );
  }

  Widget _stat(int value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppColors.textSecondary),
      title: Text(label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing:
          Icon(Icons.chevron_right, size: 18, color: AppColors.textDisabled),
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$label (mock)'))),
    );
  }
}
