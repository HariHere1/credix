import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';
import 'student_detail_screen.dart';

class StudentsTab extends StatefulWidget {
  const StudentsTab({super.key});

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = kMockStudents.where((s) {
      final q = _query.toLowerCase().trim();
      if (q.isEmpty) return true;
      return s.name.toLowerCase().contains(q) || s.rollNo.toLowerCase().contains(q) || s.batch.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          const ScreenHeader(title: 'Students', eyebrow: ''),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.xs, AppSpacing.pagePadding, AppSpacing.md),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Name or roll number',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.person_search_rounded,
                    title: 'No Students Found',
                    subtitle: 'No student matches "$_query". Try a different search term.',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.lg, AppSpacing.pagePadding, AppSpacing.lg),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text('Record placeholders · student data not provided', style: TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                      ),
                      ...filtered.map((s) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentDetailScreen(student: s))),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: AppColors.surfaceVariant,
                                          child: const Icon(Icons.person_outline, color: AppColors.textSecondary, size: 19),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('[Student name]', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                                              Text('[Roll number]', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total points', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                        Text('— / 120 pts', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: TweenAnimationBuilder<double>(
                                        duration: const Duration(milliseconds: 700),
                                        curve: Curves.easeOut,
                                        tween: Tween(begin: 0.0, end: 0.0),
                                        builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 5, color: AppColors.accent, backgroundColor: AppColors.surfaceVariant),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
