import 'package:flutter/material.dart';
import '../models/certificate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'status_chip.dart';

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final String? studentName;
  final VoidCallback onTap;

  const CertificateCard({
    super.key,
    required this.certificate,
    this.studentName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (studentName != null) ...[
                          Text(
                            studentName!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          certificate.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StatusChip(status: certificate.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      certificate.activityType,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _fmtDate(certificate.uploadDate),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              if (_isApproved(certificate) && certificate.pointsAwarded > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '+${certificate.pointsAwarded} pts',
                  style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
              if (certificate.flagReason != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.statusFlaggedBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    certificate.flagReason!,
                    style: const TextStyle(
                      color: AppColors.statusFlaggedFg,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Re-upload',
                  style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _fmtDate(String iso) {
  final parts = iso.split('-');
  if (parts.length != 3) return iso;
  const months = {'01': 'Jan','02': 'Feb','03': 'Mar','04': 'Apr','05': 'May','06': 'Jun','07': 'Jul','08': 'Aug','09': 'Sep','10': 'Oct','11': 'Nov','12': 'Dec'};
  final m = months[parts[1]] ?? parts[1];
  return '${parts[2]} $m ${parts[0]}';
}

bool _isApproved(Certificate c) =>
    c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed;
