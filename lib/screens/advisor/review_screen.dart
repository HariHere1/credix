import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_header.dart';

class ReviewScreen extends StatelessWidget {
  final Certificate certificate;
  final String studentName;
  final VoidCallback onAction;

  const ReviewScreen({super.key, required this.certificate, required this.studentName, required this.onAction});

  void _approve(BuildContext context) {
    kMockCertificates.removeWhere((c) => c.id == certificate.id);
    kMockCertificates.add(certificate.copyWith(status: CertificateStatus.reviewed, pointsAwarded: certificate.pointsIfTrusted));
    onAction();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approved "${certificate.title}" (+${certificate.pointsIfTrusted} pts)')));
  }

  Future<void> _correctAndApprove(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(context: context, builder: (_) => _CorrectApproveDialog(certificate: certificate));
    if (result != null && context.mounted) {
      final updatedType = result['type'] as String;
      final updatedPoints = result['points'] as int;
      kMockCertificates.removeWhere((c) => c.id == certificate.id);
      kMockCertificates.add(certificate.copyWith(status: CertificateStatus.reviewed, activityType: updatedType, pointsAwarded: updatedPoints));
      onAction();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Corrected & Approved: $updatedType (+$updatedPoints pts)')));
    }
  }

  Future<void> _reject(BuildContext context) async {
    final reason = await showDialog<String>(context: context, builder: (_) => const _RejectDialog());
    if (reason != null && reason.trim().isNotEmpty && context.mounted) {
      kMockCertificates.removeWhere((c) => c.id == certificate.id);
      kMockCertificates.add(certificate.copyWith(status: CertificateStatus.rejected, rejectReason: reason.trim(), pointsAwarded: 0));
      onAction();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rejected: "${certificate.title}"')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ef = certificate.extractedFields;
    return Scaffold(
      appBar: AppBar(title: const Text('Review Certificate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Certificate'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    InfoRow(label: 'Student', value: studentName),
                    InfoRow(label: 'Title', value: certificate.title),
                    InfoRow(label: 'Claimed type', value: certificate.activityType),
                    InfoRow(label: 'Upload date', value: certificate.uploadDate),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.cardRadius), border: Border.all(color: AppColors.border)),
                      child: Center(child: Text('Preview placeholder (Mock file)\n${certificate.fileName}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Extracted details'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    InfoRow(label: 'Detected type', value: ef.detectedType),
                    InfoRow(label: 'Issuer', value: ef.issuer),
                    InfoRow(label: 'Duration', value: ef.duration),
                    InfoRow(label: 'Grade', value: ef.grade),
                    InfoRow(label: 'Completion date', value: ef.completionDate),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Flag reason'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(certificate.flagReason ?? 'Unspecified flag', style: const TextStyle(color: AppColors.statusFlaggedFg, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Points if trusted'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text('${certificate.pointsIfTrusted} pts', style: const TextStyle(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Actions'),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _reject(context),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _correctAndApprove(context),
                    child: const Text('Correct & Approve'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => _approve(context),
                child: const Text('Approve (Points As Is)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectApproveDialog extends StatefulWidget {
  final Certificate certificate;
  const _CorrectApproveDialog({required this.certificate});

  @override
  State<_CorrectApproveDialog> createState() => _CorrectApproveDialogState();
}

class _CorrectApproveDialogState extends State<_CorrectApproveDialog> {
  late String _type;
  late TextEditingController _pointsCtrl;

  @override
  void initState() {
    super.initState();
    _type = kActivityTypes.contains(widget.certificate.activityType) ? widget.certificate.activityType : kActivityTypes.first;
    _pointsCtrl = TextEditingController(text: widget.certificate.pointsIfTrusted.toString());
  }

  @override
  void dispose() {
    _pointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Correct & Approve'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Modify the activity type and points before approving.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Corrected Activity Type'),
              dropdownColor: AppColors.surface,
              items: kActivityTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(controller: _pointsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points Awarded')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final pts = int.tryParse(_pointsCtrl.text.trim()) ?? widget.certificate.pointsIfTrusted;
            Navigator.of(context).pop({'type': _type, 'points': pts});
          },
          child: const Text('Approve'),
        ),
      ],
    );
  }
}

class _RejectDialog extends StatefulWidget {
  const _RejectDialog();

  @override
  State<_RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<_RejectDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reject Certificate'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Specify why this certificate is being rejected. The student will see this note.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: AppSpacing.md),
          TextField(controller: _ctrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Rejection Reason', hintText: 'e.g. Incomplete details, invalid signature, unaccredited event…', alignLabelWithHint: true)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_ctrl.text.trim().isNotEmpty) Navigator.of(context).pop(_ctrl.text.trim());
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Reject'),
        ),
      ],
    );
  }
}
