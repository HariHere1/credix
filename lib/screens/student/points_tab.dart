import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/section_header.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/premium_hero_card.dart';
import '../../widgets/circular_progress_gauge.dart';

class PointsTab extends StatelessWidget {
  const PointsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final studentId = kMockStudent.id;
    final gi = getGroupPoints(studentId, ActivityGroup.groupI);
    final gii = getGroupPoints(studentId, ActivityGroup.groupII);
    final giii = getGroupPoints(studentId, ActivityGroup.groupIII);
    final total = gi + gii + giii;
    const totalMax = 120;
    final approved = getStudentCertificates(studentId)
        .where((c) => c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed)
        .toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.lg, AppSpacing.pagePadding, AppSpacing.lg),
        children: [
          const ScreenHeader(title: 'Points'),
          // Points earned card (premium hero)
          PremiumHeroCard(
            eyebrow: 'POINTS EARNED',
            value: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: '$total', style: const TextStyle(color: AppColors.textPrimary, fontSize: 44, fontWeight: FontWeight.w500, letterSpacing: -1)),
                  TextSpan(text: ' / $totalMax', style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            subtitle: '${totalMax - total} points to go',
            trailing: CircularProgressGauge(value: total, max: totalMax, size: 120),
          ),
          const SizedBox(height: AppSpacing.xl),

          const SectionHeader(title: 'By activity group'),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GroupBar(label: 'Hackathon', earned: gi),
                  const SizedBox(height: AppSpacing.md),
                  _GroupBar(label: 'Seminar', earned: gii),
                  const SizedBox(height: AppSpacing.md),
                  _GroupBar(label: 'Workshop', earned: giii),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          SectionHeader(title: 'Points history', subtitle: '${approved.length} certificate(s) counted'),
          const SizedBox(height: AppSpacing.md),
          if (approved.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(child: Text('No approved certificates yet.', style: TextStyle(color: AppColors.textSecondary))),
            )
          else
            ...approved.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(c.uploadDate, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.accentContainer, borderRadius: BorderRadius.circular(20)),
                            child: Text('+${c.pointsAwarded} Pts', style: const TextStyle(color: AppColors.accentLight, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

}

class _GroupBar extends StatelessWidget {
  final String label;
  final int earned;

  const _GroupBar({required this.label, required this.earned});

  @override
  Widget build(BuildContext context) {
    final progress = (earned / 40).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
            Text('$earned pts', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            color: AppColors.textPrimary,
            backgroundColor: AppColors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}
