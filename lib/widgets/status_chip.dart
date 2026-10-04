import 'package:flutter/material.dart';
import '../models/certificate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class StatusChip extends StatelessWidget {
  final CertificateStatus status;
  final double fontSize;

  const StatusChip({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _statusProps(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        border: Border.all(color: fg.withOpacity(0.25), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );
  }

  static (String, Color, Color) _statusProps(CertificateStatus s) {
    return switch (s) {
      CertificateStatus.pending => ('Pending', AppColors.statusPendingBg, AppColors.statusPendingFg),
      CertificateStatus.autoApproved => ('Auto-Approved', AppColors.statusAutoApprovedBg, AppColors.statusAutoApprovedFg),
      CertificateStatus.flagged => ('Flagged', AppColors.statusFlaggedBg, AppColors.statusFlaggedFg),
      CertificateStatus.reviewed => ('Reviewed', AppColors.statusReviewedBg, AppColors.statusReviewedFg),
      CertificateStatus.rejected => ('Rejected', AppColors.statusRejectedBg, AppColors.statusRejectedFg),
    };
  }
}
