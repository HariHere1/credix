import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../admin_theme.dart';
import '../data/admin_repository.dart';
import '../widgets/admin_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardRepository repo = const MockDashboardRepository();
  final String batch = '2021–2025 demo cohort';

  void _export() {
    final book = Excel.createExcel();
    final sheet = book['Eligibility'];
    sheet.appendRow([TextCellValue('CREDIX demo cohort')]);
    sheet.appendRow([
      TextCellValue('Department'),
      TextCellValue('Students'),
      TextCellValue('Eligible'),
      TextCellValue('Eligibility %'),
    ]);
    for (final department in repo.departments) {
      final ratio = department.students == 0
          ? 0.0
          : 100 * department.eligible / department.students;
      sheet.appendRow([
        TextCellValue(department.name),
        IntCellValue(department.students),
        IntCellValue(department.eligible),
        TextCellValue('${ratio.toStringAsFixed(1)}%'),
      ]);
    }
    book.save(fileName: 'credix-eligibility.xlsx');
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 950;
          final denominator = repo.enrolled == 0 ? 1 : repo.enrolled;
          final eligibility = 100 * repo.eligible / denominator;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dashboard & Operations Overview',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w700)),
                          SizedBox(height: 6),
                          Text('Small demo cohort · counts reflect the sample records',
                              style: TextStyle(
                                  color: AdminColors.muted, fontSize: 13)),
                        ],
                      ),
                    ),
                    if (!narrow) ...[
                      StatusPill(batch),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                          onPressed: _export,
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('Export eligibility')),
                    ],
                  ],
                ),
                if (narrow) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                        onPressed: _export,
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Export eligibility')),
                  ),
                ],
                const SizedBox(height: 22),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: narrow ? 2 : 3,
                  childAspectRatio: narrow ? 1.75 : 1.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    StatCard(
                        title: 'Students',
                        value: '${repo.enrolled}',
                        note: 'Demo cohort',
                        icon: Icons.people_alt_outlined),
                    StatCard(
                        title: 'Certificates',
                        value: '${repo.submissions}',
                        note: 'Sample records',
                        icon: Icons.inventory_2_outlined,
                        color: AdminColors.slate),
                    StatCard(
                        title: 'Pending',
                        value: '${repo.pending}',
                        note: 'Awaiting review',
                        icon: Icons.pending_actions,
                        color: AdminColors.slate),
                    StatCard(
                        title: 'Flagged',
                        value: '${repo.flagged}',
                        note: 'Needs attention',
                        icon: Icons.warning_amber,
                        color: AdminColors.red),
                    StatCard(
                        title: 'Auto-approved',
                        value: '${repo.verified}',
                        note: 'Already approved',
                        icon: Icons.verified_outlined),
                    AdminCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('120 POINT REQUIREMENT',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AdminColors.greenDark)),
                          const Spacer(),
                          Text('${repo.eligible} / ${repo.enrolled}',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w700)),
                          Text('${eligibility.toStringAsFixed(0)}% eligible',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AdminColors.greenDark,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (narrow) ...[
                  _eligibility(eligibility),
                  const SizedBox(height: 16),
                  _distribution(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _eligibility(eligibility)),
                      const SizedBox(width: 16),
                      Expanded(flex: 4, child: _distribution()),
                    ],
                  ),
                const SizedBox(height: 20),
                if (narrow) ...[
                  _workload(),
                  const SizedBox(height: 16),
                  _alerts(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _workload()),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: _alerts()),
                    ],
                  ),
                const SizedBox(height: 16),
                AdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AdminSectionTitle('Recent activity',
                          subtitle: 'Sample certificate activity'),
                      const SizedBox(height: 12),
                      const Text(
                        '• Maria Garcia’s certificates were auto-approved.\n• Alex Johnson has one certificate pending tutor review.',
                        style: TextStyle(height: 1.7, fontSize: 12),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: const Text('View Full Audit Log →')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _eligibility(double overallRatio) => AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle('Degree eligibility', subtitle: batch),
            const SizedBox(height: 14),
            for (final department in repo.departments) ...[
              Row(
                children: [
                  Expanded(
                      child: Text(department.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600))),
                  Text('${department.eligible} / ${department.students}',
                      style: const TextStyle(
                          fontSize: 11, color: AdminColors.muted)),
                ],
              ),
              const SizedBox(height: 7),
              LinearProgressIndicator(
                  value: overallRatio / 100,
                  minHeight: 8,
                  color: AdminColors.green,
                  backgroundColor: const Color(0xFFE9ECEE)),
            ],
            const SizedBox(height: 12),
            const Text('Eligibility requires 120 awarded points.',
                style: TextStyle(fontSize: 11, color: AdminColors.muted)),
          ],
        ),
      );

  Widget _distribution() => AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionTitle('Average points by group',
                subtitle: 'Based on the two demo students'),
            const SizedBox(height: 16),
            for (final group in ActivityGroup.values)
              _group(group.name.replaceFirst('group', 'Group '), group),
          ],
        ),
      );

  Widget _group(String label, ActivityGroup group) {
    final points = kMockStudents.fold<int>(
        0, (sum, student) => sum + getGroupPoints(student.id, group));
    final average = repo.enrolled == 0 ? 0.0 : points / repo.enrolled;
    final utilization = (average / 40).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            Text('${average.toStringAsFixed(1)} / 40 pts'),
          ]),
          const SizedBox(height: 7),
          LinearProgressIndicator(
              value: utilization,
              minHeight: 7,
              color: AdminColors.green,
              backgroundColor: const Color(0xFFE6E9EA)),
        ],
      ),
    );
  }

  Widget _workload() => AdminCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionTitle('Advisor review workload',
                subtitle: 'One demo advisor'),
            const SizedBox(height: 12),
            const _MiniTableHeader(),
            _reviewRow((
              'TT',
              kMockAdvisor.name,
              'Computer Science',
              '${repo.submissions}',
              '${repo.pending}',
              'Demo',
              '${repo.flagged}',
            )),
          ],
        ),
      );

  Widget _reviewRow((String, String, String, String, String, String, String) r) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(children: [
          CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFD1E8DB),
              child: Text(r.$1,
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w700))),
          const SizedBox(width: 8),
          Expanded(
              flex: 3,
              child: Text(r.$2,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(r.$3)),
          Text(r.$4),
          const SizedBox(width: 15),
          Text(r.$5),
          const SizedBox(width: 14),
          Text('${r.$7} flagged'),
        ]),
      );

  Widget _alerts() {
    final alerts = <(String, String, Color)>[
      if (repo.flagged > 0)
        ('Flagged certificates', '${repo.flagged} flagged certificate(s) need review.',
            AdminColors.red),
      if (repo.pending > 0)
        ('Pending tutor review', '${repo.pending} pending certificate(s) are awaiting review.',
            AdminColors.slate),
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionTitle('Operational alerts',
              trailing: StatusPill('${alerts.length} active',
                  color: alerts.isEmpty ? AdminColors.greenDark : AdminColors.red)),
          const SizedBox(height: 12),
          if (alerts.isEmpty)
            const Text('No active review alerts.',
                style: TextStyle(fontSize: 12, color: AdminColors.muted))
          else
            for (final alert in alerts)
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: alert.$3.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.$1,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: alert.$3)),
                      Text(alert.$2,
                          style: const TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: AdminColors.muted)),
                    ]),
              ),
        ],
      ),
    );
  }
}

class _MiniTableHeader extends StatelessWidget {
  const _MiniTableHeader();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Text('ADVISOR',
                  style: TextStyle(
                      fontSize: 9,
                      color: AdminColors.muted,
                      fontWeight: FontWeight.w700))),
          Expanded(
              flex: 2,
              child: Text('DEPARTMENT',
                  style: TextStyle(
                      fontSize: 9,
                      color: AdminColors.muted,
                      fontWeight: FontWeight.w700))),
          Text('TOTAL'),
          SizedBox(width: 24),
          Text('PENDING'),
          SizedBox(width: 24),
          Text('FLAGGED'),
        ]),
      );
}
