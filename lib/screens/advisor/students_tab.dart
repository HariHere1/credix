import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
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
      appBar: AppBar(title: const Text('Students Directory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.xs, AppSpacing.pagePadding, AppSpacing.md),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search by name, roll no, or batch…',
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
                    padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0, AppSpacing.pagePadding, AppSpacing.lg),
                    children: [
                      const SectionHeader(title: 'Students'),
                      const SizedBox(height: AppSpacing.sm),
                      ...filtered.map((s) {
                        final total = getStudentPoints(s.id);
                        final progress = (total / 120).clamp(0.0, 1.0);
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
                                        Expanded(
                                          child: Text(s.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                                        ),
                                        Text('$total / 120', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text('${s.rollNo} · ${s.batch}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: TweenAnimationBuilder<double>(
                                        duration: const Duration(milliseconds: 700),
                                        curve: Curves.easeOut,
                                        tween: Tween(begin: 0, end: progress),
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
