import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../models/student.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/certificate_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/group_points_card.dart';
import '../../widgets/section_header.dart';
import '../shared/certificate_detail_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final certs = getStudentCertificates(student.id);
    final gi = getGroupPoints(student.id, ActivityGroup.groupI);
    final gii = getGroupPoints(student.id, ActivityGroup.groupII);
    final giii = getGroupPoints(student.id, ActivityGroup.groupIII);
    final total = gi + gii + giii;

    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Summary'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('$total / 120 total points', style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GroupPointsCard(groupLabel: 'GROUP I', earned: gi, max: 40, color: AppColors.groupI),
            const SizedBox(height: AppSpacing.md),
            GroupPointsCard(groupLabel: 'GROUP II', earned: gii, max: 40, color: AppColors.groupII),
            const SizedBox(height: AppSpacing.md),
            GroupPointsCard(groupLabel: 'GROUP III', earned: giii, max: 40, color: AppColors.groupIII),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Certificates'),
            const SizedBox(height: AppSpacing.md),
            if (certs.isEmpty)
              const EmptyState(
                icon: Icons.folder_open_rounded,
                title: 'No Certificates',
                subtitle: 'This student has not submitted any certificates yet.',
              )
            else
              ...certs.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CertificateCard(
                      certificate: c,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CertificateDetailScreen(certificate: c))),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
