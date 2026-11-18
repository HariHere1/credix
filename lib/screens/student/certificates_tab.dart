import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/status_chip.dart';
import '../shared/certificate_detail_screen.dart';
import 'upload_screen.dart';
import '../../models/student.dart';

class CertificatesTab extends StatefulWidget {
  final Student student;
  const CertificatesTab({super.key, this.student = kMockStudent});

  @override
  State<CertificatesTab> createState() => _CertificatesTabState();
}

class _CertificatesTabState extends State<CertificatesTab> {
  String _filter = 'All';

  List<Certificate> get _certificates =>
      getStudentCertificates(widget.student.id);

  bool _isApproved(Certificate certificate) =>
      certificate.status == CertificateStatus.autoApproved ||
      certificate.status == CertificateStatus.reviewed;

  bool _needsAttention(Certificate certificate) =>
      certificate.status == CertificateStatus.flagged ||
      certificate.status == CertificateStatus.rejected;

  bool _isPending(Certificate certificate) =>
      certificate.status == CertificateStatus.pending;

  @override
  Widget build(BuildContext context) {
    final certificates = _certificates;
    final approved = certificates.where(_isApproved).toList();
    final attention = certificates.where(_needsAttention).toList();
    final pending = certificates.where(_isPending).toList();
    final totalPoints = getStudentPoints(widget.student.id);
    final visible = switch (_filter) {
      'Needs Attention' => attention,
      'Pending' => pending,
      'Approved' => approved,
      _ => certificates,
    };

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: ScreenHeader(title: 'Certificates'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                120,
              ),
              children: [
                _summaryCard(
                  points: totalPoints,
                  submitted: certificates.length,
                  needsAction: attention.length,
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip('All', certificates.length),
                      const SizedBox(width: 8),
                      _filterChip('Needs Attention', attention.length),
                      const SizedBox(width: 8),
                      _filterChip('Pending', pending.length),
                      const SizedBox(width: 8),
                      _filterChip('Approved', approved.length),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_filter == 'All') ...[
                  _section('NEEDS ATTENTION', attention, AppColors.danger),
                  _section('IN PROGRESS', pending, AppColors.textSecondary),
                  _section('APPROVED', approved, AppColors.accent),
                ] else if (visible.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(
                      child: Text(
                        'No certificates in this view.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  _section(_filter.toUpperCase(), visible, AppColors.accent),
                const SizedBox(height: AppSpacing.sm),
                _guidelinesCard(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openUpload,
        icon: const Icon(Icons.add, color: AppColors.onAccent, size: 20),
        label: const Text(
          'Upload Certificate',
          style: TextStyle(color: AppColors.onAccent, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.accent,
        elevation: 5,
        shape: const StadiumBorder(),
      ),
    );
  }

  Widget _summaryCard({
    required int points,
    required int submitted,
    required int needsAction,
  }) {
    const maximum = 120;
    final progress = (points / maximum).clamp(0.0, 1.0);
    final tier = points >= 80 ? 3 : points >= 40 ? 2 : 1;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.whiteBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x090B1720),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'My Certificates',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D4545),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded,
                        color: AppColors.accent, size: 16),
                    const SizedBox(width: 6),
                    Text('$points / $maximum pts',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$submitted submitted · $needsAction requires action',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.verified_rounded,
                  color: AppColors.autoApprovedFg, size: 15),
              const SizedBox(width: 5),
              Text('Milestone Tier $tier',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('${maximum - points} pts to Graduation Cap',
                  style: const TextStyle(
                      color: AppColors.autoApprovedFg,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: AppColors.accent,
              backgroundColor: AppColors.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int count) {
    final selected = _filter == label;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => setState(() => _filter = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.fromLTRB(13, 8, 9, 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accent
                : AppColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label,
                style: TextStyle(
                    color: selected
                        ? AppColors.onAccent
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 7),
            Container(
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.56)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('$count',
                  style: TextStyle(
                      color: selected
                          ? AppColors.onAccent
                          : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _section(String title, List<Certificate> certificates, Color marker) {
    if (certificates.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 18,
                decoration: BoxDecoration(
                    color: marker, borderRadius: BorderRadius.circular(99)),
              ),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5)),
              const SizedBox(width: 7),
              CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.surfaceVariant,
                child: Text('${certificates.length}',
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        ...certificates.map(_certificateCard),
      ],
    );
  }

  Widget _certificateCard(Certificate certificate) {
    final attention = _needsAttention(certificate);
    final pending = _isPending(certificate);
    final statusColor = attention
        ? AppColors.danger
        : pending
            ? const Color(0xFF68718A)
            : AppColors.autoApprovedFg;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: attention
            ? const Color(0xFFFFF9F8)
            : AppColors.surfaceElevated.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: attention
                ? AppColors.danger.withValues(alpha: 0.18)
                : AppColors.whiteBorder,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openDetail(certificate),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: attention
                            ? AppColors.dangerSoft
                            : pending
                                ? const Color(0xFFEFF1FB)
                                : AppColors.accentSoft,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        attention
                            ? Icons.assignment_late_outlined
                            : pending
                                ? Icons.pending_actions_rounded
                                : Icons.verified_user_outlined,
                        color: statusColor,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(certificate.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text(
                            '${certificate.activityType} · ${_formatDate(certificate.uploadDate)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusChip(status: certificate.status, fontSize: 11),
                  ],
                ),
                if (attention) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.dangerSoft,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          const Icon(Icons.error_outline_rounded,
                              color: AppColors.danger, size: 17),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              certificate.flagReason ??
                                  certificate.rejectReason ??
                                  'Details need review',
                              style: const TextStyle(
                                  color: Color(0xFFB91C1C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        const Text(
                          'Certificate details need review before points can be credited.',
                          style: TextStyle(
                              color: Color(0xFFB91C1C), fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _openDetail(certificate),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF303536),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(38),
                            shape: const StadiumBorder(),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Fix Activity Details',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.accent,
                                child: Icon(Icons.arrow_forward_rounded,
                                    color: AppColors.onAccent, size: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (pending) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                    decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Row(children: [
                      Icon(Icons.schedule_rounded,
                          color: AppColors.autoApprovedFg, size: 16),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'In advisor review queue · Turnaround usually 3–5 days',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ),
                    ]),
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.autoApprovedFg, size: 17),
                    const SizedBox(width: 6),
                    Text('+${certificate.pointsAwarded} pts credited to transcript',
                        style: const TextStyle(
                            color: Color(0xFF006B3C),
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Certificate share link copied (Mock).')),
                      ),
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.share_outlined, size: 18),
                    ),
                  ]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _guidelinesCard() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(17)),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.menu_book_rounded,
                color: AppColors.onAccent),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity Guidelines',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  Text('Point weighting & requirements',
                      style: TextStyle(color: Color(0xFFCBD5D1), fontSize: 11)),
                ]),
          ),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Guidelines PDF is not connected in this prototype.')),
            ),
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 10)),
            icon: const Icon(Icons.download_outlined, size: 16),
            label: const Text('PDF'),
          ),
        ]),
      );

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = int.tryParse(parts[1]);
    if (month == null || month < 1 || month > 12) return date;
    return '${months[month - 1]} ${parts[2]}, ${parts[0]}';
  }

  Future<void> _openDetail(Certificate certificate) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CertificateDetailScreen(certificate: certificate)));
    if (mounted) setState(() {});
  }

  Future<void> _openUpload() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => UploadScreen(student: widget.student)));
    if (mounted) setState(() {});
  }
}
