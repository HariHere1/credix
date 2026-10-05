import 'package:flutter/material.dart';
import '../../../data/mock_data.dart';
import '../../../models/certificate.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/premium_hero_card.dart';
import '../../../widgets/circular_progress_gauge.dart';
import '../../../widgets/certificate_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/screen_header.dart';
import '../../../widgets/animated_list_item.dart';
import '../shared/certificate_detail_screen.dart';
import 'upload_screen.dart';

class CertificatesTab extends StatefulWidget {
  const CertificatesTab({super.key});

  @override
  State<CertificatesTab> createState() => _CertificatesTabState();
}

class _CertificatesTabState extends State<CertificatesTab> {
  String _filter = 'All';

  List<Certificate> get _certs => getStudentCertificates(kMockStudent.id);

  bool _isApproved(Certificate c) =>
      c.status == CertificateStatus.autoApproved ||
      c.status == CertificateStatus.reviewed;
  bool _needsAttention(Certificate c) =>
      c.status == CertificateStatus.flagged ||
      c.status == CertificateStatus.rejected ||
      c.status == CertificateStatus.pending;

  @override
  Widget build(BuildContext context) {
    final certs = _certs;
    final approvedCount = certs.where(_isApproved).length;
    final attentionCount = certs.where(_needsAttention).length;

    final filtered = switch (_filter) {
      'Approved' => certs.where(_isApproved).toList(),
      'Needs Attention' => certs.where(_needsAttention).toList(),
      _ => certs,
    };

    final total = getStudentPoints(kMockStudent.id);
    const max = 120;
    final pct = (total / max).clamp(0.0, 1.0);

    return Scaffold(
      body: Column(
        children: [
          const ScreenHeader(title: 'Certificates'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding,
                  AppSpacing.lg, AppSpacing.pagePadding, 100),
              children: [
                // Annual requirement card (premium hero)
                PremiumHeroCard(
                  eyebrow: 'ANNUAL REQUIREMENT',
                  value: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '$total',
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 44,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1)),
                        TextSpan(
                            text: ' / $max pts',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  subtitle:
                      '${(pct * 100).round()}% completed · ${max - total} pts remaining',
                  trailing:
                      CircularProgressGauge(value: total, max: max, size: 88),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _chip('All', null),
                      const SizedBox(width: AppSpacing.sm),
                      _chip('Needs Attention', attentionCount),
                      const SizedBox(width: AppSpacing.sm),
                      _chip('Approved', approvedCount),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: EmptyState(
                      icon: Icons.workspace_premium_outlined,
                      title: 'Nothing here',
                      subtitle: 'No certificates in this view.',
                    ),
                  )
                else
                  ...filtered.asMap().entries.map((e) => AnimatedListItem(
                        index: e.key,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: CertificateCard(
                              certificate: e.value,
                              onTap: () => _openDetail(e.value)),
                        ),
                      )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openUpload,
        icon: const Icon(Icons.add, color: AppColors.onAccent, size: 20),
        label: const Text('Upload',
            style: TextStyle(
                color: AppColors.onAccent, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    );
  }

  Widget _chip(String label, int? count) {
    final selected = _filter == label;
    return ChoiceChip(
      label: Text(count == null ? label : '$label ($count)',
          style: TextStyle(
              fontSize: 12,
              color: selected
                  ? AppColors.onButtonPrimary
                  : AppColors.textSecondary)),
      selected: selected,
      onSelected: (_) => setState(() => _filter = label),
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.textPrimary,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.border)),
    );
  }

  Future<void> _openDetail(Certificate c) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CertificateDetailScreen(certificate: c)));
    setState(() {});
  }

  Future<void> _openUpload() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const UploadScreen()));
    setState(() {});
  }
}
