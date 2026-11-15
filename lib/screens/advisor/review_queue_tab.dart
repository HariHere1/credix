import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';
import 'review_screen.dart';

class ReviewQueueTab extends StatefulWidget {
  final VoidCallback onQueueChanged;

  const ReviewQueueTab({super.key, required this.onQueueChanged});

  @override
  State<ReviewQueueTab> createState() => _ReviewQueueTabState();
}

class _ReviewQueueTabState extends State<ReviewQueueTab> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final pending = kMockCertificates.where((c) => c.status == CertificateStatus.pending).length;
    final flagged = getFlaggedCertificates().length;
    final autoPassed = kMockCertificates.where((c) => c.status == CertificateStatus.autoApproved).length;
    final actionable = kMockCertificates.where((c) => c.status == CertificateStatus.pending || c.status == CertificateStatus.flagged).toList()
      ..sort((a, b) => (a.status == CertificateStatus.flagged ? 0 : 1).compareTo(b.status == CertificateStatus.flagged ? 0 : 1));
    final visible = switch (_filter) {
      'Flagged' => actionable.where((c) => c.status == CertificateStatus.flagged).toList(),
      'Pending' => actionable.where((c) => c.status == CertificateStatus.pending).toList(),
      'Auto-passed' => kMockCertificates.where((c) => c.status == CertificateStatus.autoApproved).toList(),
      _ => actionable,
    };

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.sm, AppSpacing.pagePadding, AppSpacing.lg),
          children: [
            const ScreenHeader(title: 'Review queue', eyebrow: 'ADVISOR / ACTIVITY POINTS'),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              Expanded(child: _StatTile(value: '$pending', label: 'Pending', icon: Icons.hourglass_top_rounded, color: AppColors.warning)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _StatTile(value: '$flagged', label: 'Flagged', icon: Icons.flag_outlined, color: AppColors.error)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _StatTile(value: '$autoPassed', label: 'Auto-passed', icon: Icons.verified_outlined, color: AppColors.autoApprovedFg)),
            ]),
            const SizedBox(height: AppSpacing.md),
            SizedBox(height: 38, child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final label in ['All', 'Flagged', 'Pending', 'Auto-passed']) ...[
                _filterChip(label),
                if (label != 'Auto-passed') const SizedBox(width: AppSpacing.sm),
              ],
            ])),
            const SizedBox(height: AppSpacing.md),
            if (visible.isEmpty)
              const EmptyState(icon: Icons.task_alt_rounded, title: 'Queue is clear', subtitle: 'There are no activities in this view.')
            else ...visible.map((cert) => _reviewCard(context, cert)),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = _filter == label;
    return ChoiceChip(
      label: Text(label), selected: selected, onSelected: (_) => setState(() => _filter = label),
      showCheckmark: false, selectedColor: AppColors.textPrimary, backgroundColor: AppColors.surfaceVariant, side: BorderSide.none,
      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Widget _reviewCard(BuildContext context, Certificate cert) {
    final student = getStudentById(cert.studentId);
    final flagged = cert.status == CertificateStatus.flagged;
    final autoApproved = cert.status == CertificateStatus.autoApproved;
    final approved = autoApproved || cert.status == CertificateStatus.reviewed;
    final status = flagged ? 'Flagged' : approved ? 'Approved' : 'Pending';
    final statusFg = flagged
        ? AppColors.flaggedFg
        : approved
            ? AppColors.statusAutoApprovedFg
            : AppColors.statusPendingFg;
    final statusBg = flagged
        ? AppColors.flaggedBg
        : approved
            ? AppColors.statusAutoApprovedBg
            : AppColors.statusPendingBg;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          onTap: autoApproved ? null : () => _openReview(context, cert),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(radius: 17, backgroundColor: AppColors.surfaceVariant, child: Text((student?.name ?? '?').split(' ').map((p) => p.isEmpty ? '' : p[0]).take(2).join().toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(student?.name ?? 'Unknown student', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('${student?.rollNo ?? '—'} · ${student?.batch ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ])),
                _statusPill(status, statusFg, statusBg),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text(cert.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.xs),
              Row(children: [
                Expanded(child: Text('${cert.activityType} · ${cert.group.name.replaceAll('group', 'Group ')}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
                Text('${approved ? cert.pointsAwarded : cert.pointsIfTrusted} pts ${approved ? 'awarded' : 'claimed'}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
              if (flagged) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 7), decoration: BoxDecoration(color: AppColors.flaggedBg, borderRadius: BorderRadius.circular(8)), child: Text(cert.flagReason ?? 'Needs review', style: const TextStyle(color: AppColors.flaggedFg, fontSize: 11, fontWeight: FontWeight.w600))),
              ],
              const SizedBox(height: AppSpacing.sm),
              if (autoApproved)
                const Row(children: [Icon(Icons.verified_rounded, color: AppColors.autoApprovedFg, size: 15), SizedBox(width: 5), Text('Approved automatically · no tutor review needed', style: TextStyle(color: AppColors.autoApprovedFg, fontSize: 11, fontWeight: FontWeight.w600))])
              else
                const Row(children: [Icon(Icons.fact_check_outlined, color: AppColors.accentDark, size: 15), SizedBox(width: 5), Text('Review activity and document', style: TextStyle(color: AppColors.accentDark, fontSize: 11, fontWeight: FontWeight.w600)), Spacer(), Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18)]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _statusPill(String label, Color fg, Color bg) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)), child: Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700)));

  Future<void> _openReview(BuildContext context, Certificate cert) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReviewScreen(certificate: cert, studentName: getStudentById(cert.studentId)?.name ?? 'Unknown', onAction: widget.onQueueChanged)));
    if (mounted) setState(() {});
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatTile({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ])));
}
