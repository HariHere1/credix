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

class StudentAccountTab extends StatelessWidget {
  const StudentAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = kMockStudent;
    final certs = getStudentCertificates(s.id);
    final approved = certs.where((c) => c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed).length;
    final points = getStudentPoints(s.id);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.sm, AppSpacing.pagePadding, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: 'Account'),
            // Header: avatar + name + roll
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.accentSoft,
                  child: Text(
                    'XX',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(s.rollNo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Stats row
            Row(
              children: [
                Expanded(child: _stat(certs.length, 'Certificates')),
                const SizedBox(width: AppSpacing.cardGap),
                Expanded(child: _stat(approved, 'Approved')),
                const SizedBox(width: AppSpacing.cardGap),
                Expanded(child: _stat(points, 'Points')),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Profile details
            const SectionHeader(title: 'Profile'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    InfoRow(label: 'Roll number', value: s.rollNo),
                    Divider(color: AppColors.divider),
                    InfoRow(label: 'Email', value: s.email),
                    Divider(color: AppColors.divider),
                    InfoRow(label: 'Department', value: s.department),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Settings & Help'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Column(
                children: [
                  _row(context, Icons.lock_outline, 'Change password'),
                  Divider(color: AppColors.divider, height: 1),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
                    child: Align(alignment: Alignment.centerLeft, child: Text("FAQ's", style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600))),
                  ),
                  const FaqTile(
                    question: 'How are activity points added?',
                    answer: 'Points are added when a certificate is approved. Pending and flagged certificates do not count toward your total.',
                  ),
                  const FaqTile(
                    question: 'Why was my certificate flagged?',
                    answer: 'A certificate can be flagged when its type, name, or extracted details need advisor review.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Quiet danger logout
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
                icon: const Icon(Icons.logout, size: 16, color: AppColors.textSecondary),
                label: const Text('Logout', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ),
            ),
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
            Text('$value', style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppColors.textSecondary),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: Icon(Icons.chevron_right, size: 18, color: AppColors.textDisabled),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label (mock)'))),
    );
  }
}
