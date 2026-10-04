import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/group_points_card.dart';
import '../../widgets/section_header.dart';
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
      appBar: AppBar(title: const Text('My Points')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Total'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Points',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$total / $totalMax',
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    CircularProgressGauge(value: total, max: totalMax, size: 120),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'By group'),
            const SizedBox(height: AppSpacing.sm),
            GroupPointsCard(groupLabel: 'GROUP I', earned: gi, max: 40, color: AppColors.groupI),
            const SizedBox(height: AppSpacing.sm),
            GroupPointsCard(groupLabel: 'GROUP II', earned: gii, max: 40, color: AppColors.groupII),
            const SizedBox(height: AppSpacing.sm),
            GroupPointsCard(groupLabel: 'GROUP III', earned: giii, max: 40, color: AppColors.groupIII),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Points history'),
            const SizedBox(height: AppSpacing.sm),
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
                                  Text(c.activityType, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                                  Text(c.title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                ],
                              ),
                            ),
                            Text('+${c.pointsAwarded}', style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
