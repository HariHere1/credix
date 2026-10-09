import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/student.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/section_header.dart';
import '../../widgets/screen_header.dart';

class ExportTab extends StatefulWidget {
  const ExportTab({super.key});

  @override
  State<ExportTab> createState() => _ExportTabState();
}

class _ExportTabState extends State<ExportTab> {
  String _selectedFilter = 'All Activities';
  bool _submittingToPortal = false;
  bool _submittedSuccessfully = false;

  void _generateExcel() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.download_done_rounded,
              color: AppColors.accent, size: 20),
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
        title: const Text('Submit to Portal?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Confirm submission of the activity points report to the portal.'),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Activity type',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                Text(_selectedFilter,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Submit')),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Points successfully synchronized to Academic Portal.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding,
            AppSpacing.sm, AppSpacing.pagePadding, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(
                title: 'Export', eyebrow: 'ADVISOR / ACTIVITY POINTS'),
            const SizedBox(height: AppSpacing.md),
            const Text('Activity type',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(),
              dropdownColor: AppColors.surface,
              items: ['All Activities', ...kActivityTypes]
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedFilter = val;
                    _submittedSuccessfully = false;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Student preview'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.table_chart_outlined,
                            color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: AppSpacing.md),
                        const Text('Activity points report',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('STUDENT / ROLL NUMBER',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 10)),
                        Text('POINTS',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 10)),
                      ],
                    ),
                    const Divider(height: AppSpacing.lg),
                    ...kMockStudents.take(2).map((s) => _previewRow(s)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _generateExcel,
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Export Excel report'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_submittedSuccessfully)
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                    color: AppColors.statusAutoApprovedBg,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                    border: Border.all(
                        color:
                            AppColors.statusAutoApprovedFg.withOpacity(0.4))),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.statusAutoApprovedFg, size: 22),
                    const SizedBox(width: AppSpacing.sm),
                    const Expanded(
                        child: Text('Synced successfully to Academic Portal.',
                            style: TextStyle(
                                color: AppColors.statusAutoApprovedFg,
                                fontWeight: FontWeight.w600,
                                fontSize: 13))),
                    TextButton(
                        onPressed: () =>
                            setState(() => _submittedSuccessfully = false),
                        child: const Text('Reset')),
                  ],
                ),
              )
            else if (_submittingToPortal)
              const Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: LinearProgressIndicator(minHeight: 6)),
                  SizedBox(height: AppSpacing.md),
                  Text('Synchronizing points to academic portal…',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              )
            else
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitPointsToPortal,
                  icon: const Icon(Icons.north_east, size: 18),
                  label: const Text('Submit to Portal'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _previewRow(Student s) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.name,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
              SizedBox(height: 4),
              Text(s.rollNo,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          Text('${getStudentPoints(s.id)}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        ],
      );
}
