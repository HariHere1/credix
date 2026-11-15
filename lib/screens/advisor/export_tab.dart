import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_header.dart';

class ExportTab extends StatefulWidget {
  const ExportTab({super.key});

  @override
  State<ExportTab> createState() => _ExportTabState();
}

class _ExportTabState extends State<ExportTab> {
  bool _syncing = false;
  bool _synced = false;

  int get _eligible => kMockStudents.where((s) => getStudentPoints(s.id) >= 120).length;
  int get _totalPoints => kMockStudents.fold(0, (sum, s) => sum + getStudentPoints(s.id));
  int get _pending => kMockCertificates.where((c) => c.status == CertificateStatus.pending || c.status == CertificateStatus.flagged).length;
  double get _average => kMockStudents.isEmpty ? 0 : _totalPoints / kMockStudents.length;

  void _exportRoster() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Batch roster export prepared (demo).')));
  }

  Future<void> _syncPortal() async {
    setState(() { _syncing = true; _synced = false; });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() { _syncing = false; _synced = true; });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Points synchronized to the academic portal (demo).')));
  }

  @override
  Widget build(BuildContext context) {
    final total = kMockStudents.length;
    final eligibleRatio = total == 0 ? 0.0 : _eligible / total;
    final groupTotals = [
      for (final group in ActivityGroup.values)
        kMockStudents.fold(0, (sum, student) => sum + getGroupPoints(student.id, group)),
    ];
    final groupLabels = ['Group I · NSS, arts & sports', 'Group II · Workshops, internships & conferences', 'Group III · Research & innovation'];
    final groupColors = [AppColors.groupI, AppColors.groupII, AppColors.groupIII];
    final attention = kMockStudents.where((s) => getStudentPoints(s.id) == 0).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.sm, AppSpacing.pagePadding, AppSpacing.lg),
          children: [
            const ScreenHeader(title: 'Advisor portal', eyebrow: 'BATCH 2021–25 · CSE'),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              Expanded(child: _MetricCard(label: 'Points awarded', value: '$_totalPoints', icon: Icons.stars_rounded, tint: AppColors.accentDark, caption: 'Across this roster')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricCard(label: 'Class average', value: _average.toStringAsFixed(1), icon: Icons.insights_rounded, tint: AppColors.info, caption: 'Points per student')),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              Expanded(child: _MetricCard(label: 'In review', value: '$_pending', icon: Icons.pending_actions_rounded, tint: AppColors.warning, caption: 'Pending or flagged')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricCard(label: 'Requirement met', value: '$_eligible / $total', icon: Icons.verified_rounded, tint: AppColors.autoApprovedFg, caption: '120 points earned')),
            ]),
            const SizedBox(height: AppSpacing.md),
            Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.school_outlined, color: AppColors.accentDark, size: 18), const SizedBox(width: AppSpacing.sm), const Expanded(child: Text('Degree requirement progress', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700))), Text('${(eligibleRatio * 100).round()}%', style: const TextStyle(color: AppColors.autoApprovedFg, fontSize: 14, fontWeight: FontWeight.w800))]),
              const SizedBox(height: AppSpacing.sm),
              Text('$_eligible of $total students have earned 120 points', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(borderRadius: BorderRadius.circular(7), child: LinearProgressIndicator(value: eligibleRatio, minHeight: 8, color: AppColors.accentDark, backgroundColor: AppColors.surfaceVariant)),
              const SizedBox(height: AppSpacing.sm),
              const Text('120 points across four years · no semester pace implied', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ]))),
            const SizedBox(height: AppSpacing.lg),
            const Text('Points by category', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.xs),
            const Text('Awarded points across the selected roster', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: AppSpacing.sm),
            Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(children: [
              for (var i = 0; i < groupTotals.length; i++) ...[
                _GroupProgress(label: groupLabels[i], points: groupTotals[i], color: groupColors[i], max: total * 40),
                if (i < groupTotals.length - 1) const SizedBox(height: AppSpacing.md),
              ],
            ]))),
            const SizedBox(height: AppSpacing.lg),
            Row(children: [const Expanded(child: Text('Attention required', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))), Text('${attention.length}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]),
            const SizedBox(height: AppSpacing.xs),
            const Text('Students with no awarded points recorded yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: AppSpacing.sm),
            if (attention.isEmpty)
              const Card(child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Row(children: [Icon(Icons.check_circle_outline_rounded, color: AppColors.autoApprovedFg, size: 18), SizedBox(width: AppSpacing.sm), Text('Everyone has at least some points recorded.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))])))
            else
              Card(child: Column(children: [
                for (var i = 0; i < attention.length; i++) ...[
                  ListTile(dense: true, leading: CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceVariant, child: Text(attention[i].name.split(' ').map((p) => p.isEmpty ? '' : p[0]).take(2).join().toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700))), title: Text(attention[i].name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)), subtitle: Text(attention[i].rollNo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)), trailing: const Text('0 pts', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w700))),
                  if (i < attention.length - 1) const Divider(height: 1, indent: 54),
                ],
              ])),
            const SizedBox(height: AppSpacing.lg),
            const Text('Batch actions', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(onPressed: _exportRoster, icon: const Icon(Icons.download_rounded, size: 18), label: const Text('Export batch roster')),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(height: 48, child: ElevatedButton.icon(
              onPressed: _syncing ? null : _syncPortal,
              icon: Icon(_syncing ? Icons.sync_rounded : _synced ? Icons.check_circle_outline_rounded : Icons.cloud_upload_outlined, size: 18),
              label: Text(_syncing ? 'Syncing points…' : _synced ? 'Synced to academic portal' : 'Sync points to academic portal'),
            )),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color tint;
  const _MetricCard({required this.label, required this.value, required this.icon, required this.tint, required this.caption});

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: tint, size: 18),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(caption, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
      ])));
}

class _GroupProgress extends StatelessWidget {
  final String label;
  final int points;
  final int max;
  final Color color;
  const _GroupProgress({required this.label, required this.points, required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = max == 0 ? 0.0 : (points / max).clamp(0.0, 1.0);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600))), Text('$points pts', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700))]),
      const SizedBox(height: AppSpacing.xs),
      ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: progress, minHeight: 6, color: color, backgroundColor: AppColors.surfaceVariant)),
    ]);
  }
}
