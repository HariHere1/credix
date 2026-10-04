import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../../models/student.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/section_header.dart';

class ExportTab extends StatefulWidget {
  const ExportTab({super.key});

  @override
  State<ExportTab> createState() => _ExportTabState();
}

class _ExportTabState extends State<ExportTab> {
  String _selectedFilter = 'All Activities';
  bool _submittingToPortal = false;
  bool _submittedSuccessfully = false;

  List<Student> get _includedStudents {
    if (_selectedFilter == 'All Activities') return kMockStudents;
    return kMockStudents.where((s) {
      final certs = getStudentCertificates(s.id);
      return certs.any((c) =>
          c.activityType == _selectedFilter &&
          (c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed));
    }).toList();
  }

  void _generateExcel() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.download_done_rounded, color: AppColors.accent, size: 20),
          const SizedBox(width: 8),
          Text('Excel report generated for "$_selectedFilter" (Mock)'),
        ],
      ),
    ));
  }

  Future<void> _submitPointsToPortal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Submit Points to Portal'),
        content: Text('Are you sure you want to submit activity points for ${_includedStudents.length} student(s) to the university portal?\n\nThis action will sync all approved points.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm & Sync')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _submittingToPortal = true;
        _submittedSuccessfully = false;
      });
      await Future.delayed(const Duration(milliseconds: 1800));
      if (mounted) {
        setState(() {
          _submittingToPortal = false;
          _submittedSuccessfully = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Points successfully synchronized to Academic Portal.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = _includedStudents;

    return Scaffold(
      appBar: AppBar(title: const Text('Export & Portal Sync')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'Filter'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: DropdownButtonFormField<String>(
                  value: _selectedFilter,
                  decoration: const InputDecoration(labelText: 'Filter by Activity Type'),
                  dropdownColor: AppColors.surface,
                  items: ['All Activities', ...kActivityTypes].map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedFilter = val;
                        _submittedSuccessfully = false;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Preview'),
            const SizedBox(height: AppSpacing.sm),
            if (students.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: Text('No students match "$_selectedFilter"', style: const TextStyle(color: AppColors.textSecondary))),
                ),
              )
            else
              ...students.map((student) {
                final studentPts = getStudentPoints(student.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(student.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                                Text('${student.rollNo} · ${student.batch}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                          Text('$studentPts pts', style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Actions'),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: _generateExcel,
                      child: const Text('Generate Excel Report'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_submittedSuccessfully)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(color: AppColors.statusAutoApprovedBg, borderRadius: BorderRadius.circular(AppSpacing.buttonRadius), border: Border.all(color: AppColors.statusAutoApprovedFg.withOpacity(0.4))),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.statusAutoApprovedFg, size: 22),
                            const SizedBox(width: AppSpacing.sm),
                            const Expanded(child: Text('Synced successfully to Academic Portal.', style: TextStyle(color: AppColors.statusAutoApprovedFg, fontWeight: FontWeight.w600, fontSize: 13))),
                            TextButton(onPressed: () => setState(() => _submittedSuccessfully = false), child: const Text('Reset')),
                          ],
                        ),
                      )
                    else if (_submittingToPortal)
                      Column(
                        children: [
                          const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(4)), child: LinearProgressIndicator(minHeight: 6)),
                          const SizedBox(height: AppSpacing.sm),
                          const Text('Synchronizing points to academic portal…', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      )
                    else
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _submitPointsToPortal,
                          child: const Text('Submit Points to Portal'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
