import 'package:flutter/material.dart';
import '../../../data/mock_data.dart';
import '../../../models/certificate.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/certificate_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/animated_list_item.dart';
import '../../../widgets/shimmer_button.dart';
import '../shared/certificate_detail_screen.dart';
import 'upload_screen.dart';

class CertificatesTab extends StatefulWidget {
  const CertificatesTab({super.key});

  @override
  State<CertificatesTab> createState() => _CertificatesTabState();
}

class _CertificatesTabState extends State<CertificatesTab> {
  List<Certificate> get _certs => getStudentCertificates(kMockStudent.id);

  @override
  Widget build(BuildContext context) {
    final certs = _certs;
    final needsAttention = certs.where((c) => c.status == CertificateStatus.flagged || c.status == CertificateStatus.rejected).toList();
    final inProgress = certs.where((c) => c.status == CertificateStatus.pending).toList();
    final approved = certs.where((c) => c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Certificates')),
      body: certs.isEmpty
          ? EmptyState(
              icon: Icons.workspace_premium_outlined,
              title: 'No Certificates Yet',
              subtitle: 'Upload your first certificate to get started.',
              action: ShimmerButton(
                onPressed: _openUpload,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.upload_file_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('Upload Certificate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.md, AppSpacing.pagePadding, 100),
              children: [
                if (needsAttention.isNotEmpty) ...[
                  const SectionHeader(title: 'Needs attention'),
                  const SizedBox(height: AppSpacing.sm),
                  ...needsAttention.asMap().entries.map((e) => AnimatedListItem(index: e.key, child: Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: CertificateCard(certificate: e.value, onTap: () => _openDetail(e.value))))),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (inProgress.isNotEmpty) ...[
                  const SectionHeader(title: 'In progress'),
                  const SizedBox(height: AppSpacing.sm),
                  ...inProgress.asMap().entries.map((e) => AnimatedListItem(index: e.key, child: Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: CertificateCard(certificate: e.value, onTap: () => _openDetail(e.value))))),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (approved.isNotEmpty) ...[
                  const SectionHeader(title: 'Approved'),
                  const SizedBox(height: AppSpacing.sm),
                  ...approved.asMap().entries.map((e) => AnimatedListItem(index: e.key, child: Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: CertificateCard(certificate: e.value, onTap: () => _openDetail(e.value))))),
                ],
              ],
            ),
      floatingActionButton: certs.isNotEmpty
          ? ShimmerButton(
              onPressed: _openUpload,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.upload_file_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text('Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : null,
    );
  }

  Future<void> _openDetail(Certificate c) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => CertificateDetailScreen(certificate: c)));
    setState(() {});
  }

  Future<void> _openUpload() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UploadScreen()));
    setState(() {});
  }
}
