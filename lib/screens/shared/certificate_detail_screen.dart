import 'package:flutter/material.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_chip.dart';

class CertificateDetailScreen extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailScreen({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    final ef = certificate.extractedFields;
    final statusLabel = switch (certificate.status) {
      CertificateStatus.pending => 'Pending',
      CertificateStatus.autoApproved => 'Auto-Approved',
      CertificateStatus.flagged => 'Flagged',
      CertificateStatus.reviewed => 'Reviewed',
      CertificateStatus.rejected => 'Rejected',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Certificate'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    InfoRow(label: 'Title', value: certificate.title),
                    InfoRow(label: 'Activity type', value: certificate.activityType),
                    InfoRow(label: 'File name', value: certificate.fileName),
                    InfoRow(label: 'Upload date', value: certificate.uploadDate),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Extracted details'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    InfoRow(label: 'Detected type', value: ef.detectedType),
                    InfoRow(label: 'Issuer', value: ef.issuer),
                    InfoRow(label: 'Duration', value: ef.duration),
                    InfoRow(label: 'Grade', value: ef.grade),
                    InfoRow(label: 'Completion date', value: ef.completionDate),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Status'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusChip(status: certificate.status),
                        const SizedBox(width: AppSpacing.sm),
                        Text(statusLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                    if (certificate.flagReason != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      const Text('Flag reason', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(certificate.flagReason!, style: const TextStyle(color: AppColors.statusFlaggedFg, fontSize: 13)),
                    ],
                    if (certificate.rejectReason != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      const Text('Reject reason', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(certificate.rejectReason!, style: const TextStyle(color: AppColors.statusRejectedFg, fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ),
            if (certificate.pointsAwarded > 0) ...[
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Points'),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    '+${certificate.pointsAwarded} points awarded',
                    style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
