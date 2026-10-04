import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
import 'review_screen.dart';

class ReviewQueueTab extends StatelessWidget {
  final VoidCallback onQueueChanged;

  const ReviewQueueTab({super.key, required this.onQueueChanged});

  @override
  Widget build(BuildContext context) {
    final flagged = getFlaggedCertificates();

    // Group by flag reason
    final Map<String, List<Certificate>> byReason = {};
    for (final c in flagged) {
      final reason = c.flagReason ?? 'Unspecified';
      byReason.putIfAbsent(reason, () => []).add(c);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Review Queue'),
            const SizedBox(width: AppSpacing.sm),
            if (flagged.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.statusFlaggedBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.statusFlaggedFg.withOpacity(0.3)),
                ),
                child: Text('${flagged.length}', style: const TextStyle(color: AppColors.statusFlaggedFg, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
      body: flagged.isEmpty
          ? const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'All Clear!',
              subtitle: 'There are no flagged certificates awaiting review.',
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: byReason.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: entry.key),
                    const SizedBox(height: AppSpacing.sm),
                    ...entry.value.map((cert) {
                      final student = getStudentById(cert.studentId);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            onTap: () async {
                              await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ReviewScreen(
                                  certificate: cert,
                                  studentName: student?.name ?? 'Unknown Student',
                                  onAction: onQueueChanged,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(student?.name ?? 'Unknown Student', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(cert.title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    children: [
                                      Text(cert.activityType, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                                      const Text(' · ', style: TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                                      Text('${cert.pointsIfTrusted} pts', style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(color: AppColors.statusFlaggedBg, borderRadius: BorderRadius.circular(6)),
                                        child: const Text('Flagged', style: TextStyle(color: AppColors.statusFlaggedFg, fontSize: 11, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
