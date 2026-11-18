import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/circular_progress_gauge.dart';
import '../../widgets/screen_header.dart';
import '../../models/student.dart';

class PointsTab extends StatelessWidget {
  final Student student;
  const PointsTab({super.key, this.student = kMockStudent});

  @override
  Widget build(BuildContext context) {
    final studentId = student.id;
    final pointsByGroup = <ActivityGroup, int>{
      ActivityGroup.groupI: getGroupPoints(studentId, ActivityGroup.groupI),
      ActivityGroup.groupII: getGroupPoints(studentId, ActivityGroup.groupII),
      ActivityGroup.groupIII: getGroupPoints(studentId, ActivityGroup.groupIII),
    };
    final total = pointsByGroup.values.fold<int>(0, (sum, value) => sum + value);
    final certificates = getStudentCertificates(studentId);
    final approved = certificates
        .where((certificate) =>
            certificate.status == CertificateStatus.autoApproved ||
            certificate.status == CertificateStatus.reviewed)
        .toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    final flagged = certificates
        .where((certificate) =>
            certificate.status == CertificateStatus.flagged ||
            certificate.status == CertificateStatus.rejected)
        .length;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          112,
        ),
        children: [
          const ScreenHeader(title: 'Points'),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(999)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, color: AppColors.autoApprovedFg, size: 8),
                SizedBox(width: 7),
                Text('Active Academic Cycle',
                    style: TextStyle(
                        color: AppColors.autoApprovedFg,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Text('My Points',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 27,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.7)),
              ),
              Text('KTU 2024 Regs',
                  style: const TextStyle(
                      color: AppColors.autoApprovedFg,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 5),
          const Text('B.Tech Computer Science · Academic Year 2024–25',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: AppSpacing.lg),
          _pointsHero(total),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(Icons.pie_chart_outline_rounded,
                  color: AppColors.autoApprovedFg, size: 20),
              const SizedBox(width: 7),
              const Expanded(
                child: Text('BREAKDOWN BY GROUP',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3)),
              ),
              Text('40 Max / Group',
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _groupCard(
            group: 'GROUP I',
            title: 'Technical & Professional Development',
            points: pointsByGroup[ActivityGroup.groupI]!,
            icon: Icons.terminal_rounded,
            iconColor: AppColors.autoApprovedFg,
            iconBackground: AppColors.accentSoft,
            detail: 'Hackathons, technical training and presentations.',
            chips: const ['Hackathons', 'Paper Presentation', 'Bootcamps'],
          ),
          const SizedBox(height: AppSpacing.md),
          _groupCard(
            group: 'GROUP II',
            title: 'Sports, Cultural & NSS',
            points: pointsByGroup[ActivityGroup.groupII]!,
            icon: Icons.sports_martial_arts_rounded,
            iconColor: const Color(0xFF58617A),
            iconBackground: const Color(0xFFECEFF8),
            detail: flagged > 0
                ? '$flagged flagged submission pending revision'
                : 'Sports, arts, volunteering and service activities.',
            flagged: flagged > 0,
          ),
          const SizedBox(height: AppSpacing.md),
          _groupCard(
            group: 'GROUP III',
            title: 'Leadership, Clubs & Social Impact',
            points: pointsByGroup[ActivityGroup.groupIII]!,
            icon: Icons.groups_rounded,
            iconColor: AppColors.autoApprovedFg,
            iconBackground: AppColors.accentSoft,
            detail: 'Student council, tech fests, outreach and green campus initiatives.',
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Expanded(
                child: Text('RECENT ACTIVITY CREDITS',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3)),
              ),
              Text('${approved.length} Verified',
                  style: const TextStyle(
                      color: AppColors.autoApprovedFg,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (approved.isEmpty)
            const _EmptyCreditsCard()
          else
            ...approved.map((certificate) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _creditCard(context, certificate),
                )),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Points summary PDF is not connected in this prototype.')),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF414646),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.download_rounded, color: AppColors.accent),
              label: const Text('Download Points Summary Report (PDF)',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsHero(int total) {
    const maximum = 120;
    final remaining = (maximum - total).clamp(0, maximum);
    final percent = ((total / maximum) * 100).round().clamp(0, 100);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg + 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDFEFE), Color(0xFFF0FBF6)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.whiteBorder),
        boxShadow: const [
          BoxShadow(
              color: Color(0x090B1720), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL POINTS EARNED',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$total',
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            color: AppColors.textPrimary,
                            fontSize: 48,
                            height: 0.98,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            'of 120 pts',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '$percent% of your 120-point requirement',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              CircularProgressGauge(
                value: total < 0
                    ? 0
                    : total > maximum
                        ? maximum
                        : total,
                max: maximum,
                size: 94,
                secondary: const Color(0xFFE7ECE9),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8F1EC)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.hourglass_bottom_rounded,
                    color: AppColors.autoApprovedFg,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '$remaining points remaining',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text(
                  'Degree target',
                  style: TextStyle(
                    color: AppColors.autoApprovedFg,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupCard({
    required String group,
    required String title,
    required int points,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String detail,
    List<String> chips = const [],
    bool flagged = false,
  }) {
    final progress = (points / 40).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.whiteBorder),
        boxShadow: const [
          BoxShadow(
              color: Color(0x080B1720), blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: iconBackground, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group,
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 11,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ]),
          ),
          Text('$points',
              style: TextStyle(
                  color: points == 0 ? AppColors.textSecondary : AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const Padding(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: Text('/ 40 pts',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              color: AppColors.accent,
              backgroundColor: AppColors.surfaceVariant),
        ),
        if (chips.isNotEmpty) ...[
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: chips.map((chip) {
              final value = chip == 'Hackathons' ? points : 0;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(999)),
                child: Text('$chip: $value pts',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              );
            }).toList(),
          ),
        ] else ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              color: flagged ? AppColors.dangerSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              if (flagged) ...[
                const Icon(Icons.error_outline, color: AppColors.danger, size: 16),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(detail,
                    style: TextStyle(
                        color: flagged
                            ? const Color(0xFFB91C1C)
                            : AppColors.textSecondary,
                        fontSize: 12)),
              ),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _creditCard(BuildContext context, Certificate certificate) {
    final groupName = switch (certificate.group) {
      ActivityGroup.groupI => 'Group I',
      ActivityGroup.groupII => 'Group II',
      ActivityGroup.groupIII => 'Group III',
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.whiteBorder),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(_activityIcon(certificate.activityType),
                color: AppColors.onAccent, size: 21),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(certificate.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(999)),
            child: Text('+${certificate.pointsAwarded} Pts',
                style: const TextStyle(
                    color: AppColors.onAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.calendar_today_outlined,
              color: AppColors.textSecondary, size: 14),
          const SizedBox(width: 6),
          Text(_formatDate(certificate.uploadDate),
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(width: 7),
          const Text('·', style: TextStyle(color: AppColors.accent)),
          const SizedBox(width: 7),
          Text(groupName,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const Spacer(),
          TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Certificate viewer is a mock preview.')),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            icon: const Icon(Icons.visibility_outlined, size: 15),
            label: const Text('View Certificate', style: TextStyle(fontSize: 11)),
          ),
        ]),
      ]),
    );
  }

  IconData _activityIcon(String activity) {
    final value = activity.toLowerCase();
    if (value.contains('sport')) return Icons.emoji_events_outlined;
    if (value.contains('club')) return Icons.groups_2_outlined;
    return Icons.workspace_premium_outlined;
  }

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
}

class _EmptyCreditsCard extends StatelessWidget {
  const _EmptyCreditsCard();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(
          child: Text('Approved activity credits will appear here.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
      );
}
