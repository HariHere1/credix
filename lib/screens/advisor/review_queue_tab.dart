import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_header.dart';
import 'review_screen.dart';

class ReviewQueueTab extends StatefulWidget {
  final VoidCallback onQueueChanged;

  const ReviewQueueTab({super.key, required this.onQueueChanged});

  @override
  State<ReviewQueueTab> createState() => _ReviewQueueTabState();
}

class _ReviewQueueTabState extends State<ReviewQueueTab> {
  @override
  Widget build(BuildContext context) {
    final allFlagged = getFlaggedCertificates();
    final visible = allFlagged.take(2).toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.lg, AppSpacing.pagePadding, AppSpacing.lg),
        children: [
          const ScreenHeader(title: 'Review Queue', eyebrow: 'ADVISOR / ACTIVITY POINTS'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: _StatTile(value: '—', label: 'In queue')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _StatTile(value: '—', label: 'Flagged')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _StatTile(value: '—', label: 'Reviewed')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (_) {},
                  backgroundColor: AppColors.surfaceVariant,
                  selectedColor: AppColors.textPrimary,
                  showCheckmark: false,
                  labelStyle: const TextStyle(color: AppColors.onButtonPrimary, fontSize: 12),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Type mismatch'),
                  selected: false,
                  onSelected: (_) {},
                  backgroundColor: AppColors.surfaceVariant,
                  showCheckmark: false,
                  labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          ...visible.map((cert) => _reviewCard(context, cert)),
        ],
      ),
    );
  }

  Widget _reviewCard(BuildContext context, Certificate cert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getStudentById(cert.studentId)?.name ?? 'Unknown', style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              Text(getStudentById(cert.studentId)?.rollNo ?? '—', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: AppSpacing.md),
              _detail('Claimed type', cert.activityType),
              _detail('OCR-detected type', cert.extractedFields.detectedType),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(14)),
                child: Text(cert.flagReason ?? 'Flagged', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () => _openReview(context, cert), child: const Text('Approve'))),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: OutlinedButton(onPressed: () => _openReview(context, cert), child: const Text('Reject'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
          ],
        ),
      );

  Future<void> _openReview(BuildContext context, Certificate cert) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReviewScreen(
        certificate: cert,
        studentName: getStudentById(cert.studentId)?.name ?? 'Unknown',
        onAction: widget.onQueueChanged,
      ),
    ));
    if (mounted) setState(() {});
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;

  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value', style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 0.8)),
          ],
        ),
      ),
    );
  }
}
