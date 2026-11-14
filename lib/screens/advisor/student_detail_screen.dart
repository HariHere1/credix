import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../models/student.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/group_points_card.dart';
import '../../widgets/section_header.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final points = getStudentPoints(student.id);
    final history = getStudentSemesterPoints(student.id).entries.toList()
      ..sort((a, b) => int.parse(a.key.split(' ').last).compareTo(int.parse(b.key.split(' ').last)));
    final gi = getGroupPoints(student.id, ActivityGroup.groupI);
    final gii = getGroupPoints(student.id, ActivityGroup.groupII);
    final giii = getGroupPoints(student.id, ActivityGroup.groupIII);
    final progress = (points / 120).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(student.rollNo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: AppSpacing.xs),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('$points', style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  const Padding(padding: EdgeInsets.only(bottom: 4), child: Text(' / 120 points', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))),
                  const Spacer(),
                  Text(points >= 120 ? 'Requirement met' : '${120 - points} remaining', style: TextStyle(color: points >= 120 ? AppColors.autoApprovedFg : AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: progress, minHeight: 7, color: AppColors.accentDark, backgroundColor: AppColors.surfaceVariant)),
                const SizedBox(height: AppSpacing.sm),
                const Text('Degree requirement across four years', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ]),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Points by category'),
          const SizedBox(height: AppSpacing.sm),
          GroupPointsCard(groupLabel: 'GROUP I', earned: gi, max: 40, color: AppColors.groupI),
          const SizedBox(height: AppSpacing.sm),
          GroupPointsCard(groupLabel: 'GROUP II', earned: gii, max: 40, color: AppColors.groupII),
          const SizedBox(height: AppSpacing.sm),
          GroupPointsCard(groupLabel: 'GROUP III', earned: giii, max: 40, color: AppColors.groupIII),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Semester point history'),
          const SizedBox(height: AppSpacing.xs),
          const Text('Awarded points only. Certificate files are not shown in this history.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: AppSpacing.sm),
          if (history.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No points have been awarded yet.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))))
          else
            Card(
              child: Column(children: [
                for (var i = 0; i < history.length; i++) ...[
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(radius: 15, backgroundColor: AppColors.accentSoft, child: Text(history[i].key.split(' ').last, style: const TextStyle(color: AppColors.accentDark, fontSize: 10, fontWeight: FontWeight.w700))),
                    title: Text(history[i].key, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: Text('+${history[i].value} pts', style: const TextStyle(color: AppColors.autoApprovedFg, fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                  if (i < history.length - 1) const Divider(height: 1, indent: 52),
                ],
              ]),
            ),
        ],
      ),
    );
  }
}
