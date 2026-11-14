import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/student.dart';
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
  String _filter = 'All';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = kMockStudents.length;
    final eligible = kMockStudents.where((s) => getStudentPoints(s.id) >= 120).length;
    final q = _query.trim().toLowerCase();
    final filtered = kMockStudents.where((s) {
      final matchesQuery = q.isEmpty || s.name.toLowerCase().contains(q) || s.rollNo.toLowerCase().contains(q);
      final points = getStudentPoints(s.id);
      final matchesFilter = _filter == 'All' || (_filter == 'Eligible' ? points >= 120 : points < 120);
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
              child: ScreenHeader(title: 'Students', eyebrow: 'ADVISOR / ROSTER'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.xs, AppSpacing.pagePadding, AppSpacing.md),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search name or roll number',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
                  suffixIcon: _query.isEmpty ? null : IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                  ),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyState(icon: Icons.person_search_rounded, title: 'No students found', subtitle: 'Try another name or roll number.')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0, AppSpacing.pagePadding, AppSpacing.lg),
                      children: [
                        _requirementCard(total, eligible),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(child: Text('Student roster', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
                            Text('${filtered.length} students', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _filters(),
                        const SizedBox(height: AppSpacing.sm),
                        ...filtered.map(_studentCard),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requirementCard(int total, int eligible) {
    final progress = total == 0 ? 0.0 : eligible / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.school_outlined, color: AppColors.accentDark, size: 18),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(child: Text('Degree requirement', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600))),
            Text('${(progress * 100).round()}% eligible', style: const TextStyle(color: AppColors.autoApprovedFg, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text('$eligible of $total students have earned 120 points', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 7, color: AppColors.accentDark, backgroundColor: AppColors.surfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          const Text('120 points required for degree completion across four years', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ]),
      ),
    );
  }

  Widget _filters() => SizedBox(
        height: 38,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _filterChip('All'),
            const SizedBox(width: AppSpacing.sm),
            _filterChip('In progress'),
            const SizedBox(width: AppSpacing.sm),
            _filterChip('Eligible'),
          ],
        ),
      );

  Widget _filterChip(String label) {
    final selected = _filter == label;
    return ChoiceChip(
      label: Text(label), selected: selected,
      onSelected: (_) => setState(() => _filter = label),
      showCheckmark: false,
      selectedColor: AppColors.textPrimary,
      backgroundColor: AppColors.surfaceVariant,
      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
      side: BorderSide.none,
    );
  }

  Widget _studentCard(Student student) {
    final points = getStudentPoints(student.id);
    final remaining = (120 - points).clamp(0, 120);
    final eligible = points >= 120;
    final progress = (points / 120).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentDetailScreen(student: student))),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(radius: 20, backgroundColor: AppColors.accentSoft, child: Text(student.name.split(' ').map((part) => part.isEmpty ? '' : part[0]).take(2).join().toUpperCase(), style: const TextStyle(color: AppColors.accentDark, fontSize: 12, fontWeight: FontWeight.w700))),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(student.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(student.rollNo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('$points / 120 pts', style: TextStyle(color: eligible ? AppColors.autoApprovedFg : AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(eligible ? 'Requirement met' : '$remaining remaining', style: TextStyle(color: eligible ? AppColors.autoApprovedFg : AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
                ]),
              ]),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: progress, minHeight: 5, color: eligible ? AppColors.autoApprovedFg : AppColors.accent, backgroundColor: AppColors.surfaceVariant)),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                const Icon(Icons.history_rounded, size: 14, color: AppColors.accentDark),
                const SizedBox(width: 5),
                const Expanded(child: Text('View points by semester', style: TextStyle(color: AppColors.accentDark, fontSize: 11, fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textSecondary),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
