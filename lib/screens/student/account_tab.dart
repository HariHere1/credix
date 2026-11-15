import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_header.dart';
import '../auth/login_screen.dart';

class StudentAccountTab extends StatelessWidget {
  const StudentAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final student = kMockStudent;
    const maximum = 120;
    final points = getStudentPoints(student.id);
    final progress = (points / maximum).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final initials = student.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          110,
        ),
        children: [
          const ScreenHeader(title: 'Account'),
          const SizedBox(height: 4),
          _portalSyncBanner(),
          const SizedBox(height: AppSpacing.lg),
          _profileCard(student.name, student.department, initials),
          const SizedBox(height: AppSpacing.lg),
          _quotaCard(points, maximum, percent, progress),
          const SizedBox(height: AppSpacing.lg),
          _institutionalRecords(context, student.rollNo, student.email, student.batch),
          const SizedBox(height: AppSpacing.lg),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('SESSION',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8)),
          ),
          _sessionCard(context),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: TextButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Helpdesk link is not connected in this prototype.')),
              ),
              icon: const Icon(Icons.menu_book_outlined, size: 17),
              label: const Text('Academic Helpdesk & Regulations'),
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.autoApprovedFg,
                  textStyle: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const Center(
            child: Text('CREDIX · v2.4.1',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _portalSyncBanner() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: AppColors.surfaceElevated.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.whiteBorder)),
        child: Row(children: [
          const Icon(Icons.circle, color: AppColors.accent, size: 8),
          const SizedBox(width: 7),
          const Expanded(
            child: Text('Portal synced with University Registry',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(999)),
            child: const Text('Live Hub',
                style: TextStyle(
                    color: AppColors.autoApprovedFg,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
      );

  Widget _profileCard(String name, String department, String initials) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.whiteBorder),
          boxShadow: const [
            BoxShadow(
                color: Color(0x090B1720), blurRadius: 18, offset: Offset(0, 8)),
          ],
        ),
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentSoft,
                border: Border.all(color: AppColors.accent, width: 3),
              ),
              child: Center(
                child: Text(initials,
                    style: const TextStyle(
                        color: AppColors.autoApprovedFg,
                        fontSize: 30,
                        fontWeight: FontWeight.w800)),
              ),
            ),
            Positioned(
              right: -1,
              bottom: 1,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.onAccent, size: 17),
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.md),
          Text(name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4)),
          const SizedBox(height: 4),
          Text(department,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(999)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle, color: AppColors.accent, size: 9),
              SizedBox(width: 7),
              Text('Academic Good Standing',
                  style: TextStyle(
                      color: AppColors.autoApprovedFg,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
      );

  Widget _quotaCard(int points, int maximum, int percent, double progress) =>
      Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF323A3A), Color(0xFF43564E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A111827), blurRadius: 15, offset: Offset(0, 7)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.workspace_premium_outlined,
                color: AppColors.accent, size: 17),
            const SizedBox(width: 7),
            const Expanded(
              child: Text('ACCREDITATION QUOTA',
                  style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w800)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(999)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified_rounded, color: AppColors.accent, size: 13),
                SizedBox(width: 4),
                Text('Tracking',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '$points',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w800)),
                  TextSpan(
                      text: ' / $maximum Points',
                      style: const TextStyle(
                          color: Color(0xFFCBD5D1), fontSize: 14)),
                ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Text('$percent%',
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: AppColors.accent,
                backgroundColor: Colors.white.withValues(alpha: 0.15)),
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.flag_outlined, color: AppColors.accent, size: 15),
            const SizedBox(width: 6),
            Expanded(
              child: Text('${maximum - points} pts left to graduation clearance',
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
            const Text('In Progress',
                style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ]),
        ]),
      );

  Widget _institutionalRecords(
      BuildContext context, String roll, String email, String batch) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.whiteBorder),
        boxShadow: const [
          BoxShadow(
              color: Color(0x090B1720), blurRadius: 15, offset: Offset(0, 7)),
        ],
      ),
      child: Column(children: [
        Row(children: [
          const Expanded(
            child: Text('INSTITUTIONAL RECORDS',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w800)),
          ),
          IconButton(
            tooltip: 'Copy institutional details',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Institutional details copied (Mock).')),
            ),
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.badge_outlined,
                color: AppColors.textPrimary, size: 19),
          ),
        ]),
        _recordRow(
          icon: Icons.tag_rounded,
          label: 'Roll Number',
          value: roll,
          trailing: IconButton(
            tooltip: 'Copy roll number',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Roll number copied (Mock).')),
            ),
            icon: const Icon(Icons.copy_rounded, size: 17),
          ),
        ),
        const SizedBox(height: 5),
        _recordRow(
          icon: Icons.alternate_email_rounded,
          label: 'College Email',
          value: email,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(999)),
            child: const Text('Verified',
                style: TextStyle(
                    color: AppColors.autoApprovedFg,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 5),
        Row(children: [
          Expanded(
              child: _miniRecord(Icons.calendar_today_outlined,
                  'Academic Batch', batch)),
          const SizedBox(width: 6),
          Expanded(
              child: _miniRecord(
                  Icons.school_outlined, 'Enrolled Term', 'Semester 7')),
        ]),
      ]),
    );
  }

  Widget _recordRow({
    required IconData icon,
    required String label,
    required String value,
    required Widget trailing,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: AppColors.autoApprovedFg, size: 19),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ]),
          ),
          trailing,
        ]),
      );

  Widget _miniRecord(IconData icon, String label, String value) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 5),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 6),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _sessionCard(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.whiteBorder),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.devices_outlined,
                  color: AppColors.textPrimary, size: 21),
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Device',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Text('Active Mobile Session · iOS Client',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ]),
            ),
            const Icon(Icons.circle, color: AppColors.accent, size: 10),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFDDDA),
                foregroundColor: const Color(0xFFB91C1C),
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.logout_rounded, size: 17),
              label: const Expanded(
                  child: Text('Log Out of Student Hub',
                      style: TextStyle(fontWeight: FontWeight.w700))),
              iconAlignment: IconAlignment.start,
            ),
          ),
        ]),
      );
}
