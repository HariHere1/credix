import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _selectedFileName;
  String _selectedType = kActivityTypes.first;
  final _labelCtrl = TextEditingController();
  bool _submitting = false;

  bool get _showLabelField => _selectedType == 'Other';

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _selectedFileName = result.files.first.name);
      }
    } catch (e) {
      // FilePicker may be unavailable in some environments
      setState(() => _selectedFileName = 'sample_certificate.pdf');
    }
  }

  Future<void> _submit() async {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a file first.')));
      return;
    }
    if (_showLabelField && _labelCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe the activity.')));
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final activityType = _showLabelField ? _labelCtrl.text.trim() : _selectedType;

    final newCert = Certificate(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      studentId: kMockStudent.id,
      title: '$activityType Certificate',
      activityType: activityType,
      group: ActivityGroup.groupI,
      uploadDate: _today(),
      status: CertificateStatus.pending,
      fileName: _selectedFileName!,
      extractedFields: const ExtractedFields(
        detectedType: 'Detecting…',
        issuer: 'Detecting…',
        duration: 'Detecting…',
        grade: 'Detecting…',
        completionDate: 'Detecting…',
      ),
      pointsAwarded: 0,
      pointsIfTrusted: 10,
    );

    kMockCertificates.add(newCert);

    if (mounted) {
      setState(() => _submitting = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Certificate uploaded — status: Pending')));
    }
  }

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Certificate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Upload a certificate to claim activity points.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: _selectedFileName != null ? AppColors.accentContainer : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(color: _selectedFileName != null ? AppColors.accent : AppColors.border, width: _selectedFileName != null ? 1.5 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedFileName != null ? Icons.insert_drive_file_rounded : Icons.upload_file_rounded,
                      size: 36,
                      color: _selectedFileName != null ? AppColors.accent : AppColors.textDisabled,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFileName ?? 'Tap to select a file',
                      style: TextStyle(color: _selectedFileName != null ? AppColors.accent : AppColors.textDisabled, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedFileName != null ? 'Tap to change' : 'PDF, JPG, or PNG',
                      style: const TextStyle(color: AppColors.textDisabled, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Activity Type'),
              dropdownColor: AppColors.surface,
              items: kActivityTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _selectedType = v ?? _selectedType),
            ),
            if (_showLabelField) ...[
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _labelCtrl,
                decoration: const InputDecoration(labelText: 'Describe the Activity', hintText: 'e.g., Paper Presentation at XYZ College'),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Submit Certificate'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Your certificate will be processed by OCR and auto-approved if confidence is high enough. Otherwise it will be queued for advisor review.',
              style: TextStyle(color: AppColors.textDisabled, fontSize: 11, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
