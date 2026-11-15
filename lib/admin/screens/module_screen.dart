import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart' as mui;

import '../../data/mock_data.dart';
import '../../models/certificate.dart';
import '../admin_theme.dart';
import '../models/admin_user.dart';
import '../mock_data/admin_mock_data.dart';
import '../services/audit_service.dart';
import '../widgets/admin_card.dart';
import '../widgets/confirm_reason_dialog.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key, required this.section, required this.user});
  final String section;
  final AdminUser user;
  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  int subtab = 0;
  String query = '';
  final selected = <int>{};
  final audit = AuditService.instance;
  late final _StudentSource _studentSource;
  late final _SubmissionSource _submissionSource;
  bool get canEdit => widget.user.role.canEdit;

  @override
  void initState() {
    super.initState();
    const names = [
      'Akhil Thomas',
      'Ananya S.',
      'Arjun Raj',
      'Diya Joseph',
      'Nikhil Babu',
      'Sneha Mathew',
      'Joel George'
    ];
    _studentSource = _StudentSource(
      widget.user.role == AdminRole.departmentAdmin
          ? names.take(3).toList()
          : names,
      widget.user.role,
      selected,
      onAction: (name) =>
          _change('Edit student', name, 'Status: Active', 'Status: Updated'),
    );
    _submissionSource = _SubmissionSource(
      canEdit,
      (target, action) => _change(action, target, 'Pending review', 'Approved'),
      kMockCertificates,
      departmentAdmin: widget.user.role == AdminRole.departmentAdmin,
    );
  }

  @override
  void dispose() {
    _studentSource.dispose();
    _submissionSource.dispose();
    super.dispose();
  }

  Future<void> _change(
      String action, String target, String oldValue, String newValue) async {
    if (!canEdit) return;
    final reason = await confirmWithReason(context,
        title: action, target: target, oldValue: oldValue, newValue: newValue);
    if (reason == null) return;
    audit.log(
        actor: widget.user.name,
        role: widget.user.role.label,
        action: action,
        target: target,
        oldValue: oldValue,
        newValue: newValue,
        reason: reason);
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$action saved and added to audit log')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final later = [
      'Reports',
      'Detection Settings',
      'Announcements',
      'Academic Year',
      'System Settings'
    ].contains(widget.section);
    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(widget.section,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700))),
            if (!canEdit)
              const StatusPill('READ ONLY', color: AdminColors.slate)
          ]),
          const SizedBox(height: 5),
          const Text('SJCET Palai 2024 Scheme',
              style: TextStyle(color: AdminColors.muted, fontSize: 12)),
          const SizedBox(height: 18),
          if (later)
            _comingSoon()
          else
            switch (widget.section) {
              'Users' => _users(),
              'Submissions' => _submissions(),
              'Rulebook' => _rulebook(),
              'Audit Log' => _audit(),
              _ => _comingSoon(),
            },
        ]));
  }

  Widget _comingSoon() => AdminCard(
      child: SizedBox(
          width: double.infinity,
          height: 240,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.hourglass_empty,
                size: 34, color: AdminColors.muted),
            const SizedBox(height: 12),
            const Text('Coming soon',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 5),
            Text('${widget.section} is planned for a later phase.',
                style: const TextStyle(color: AdminColors.muted))
          ])));

  Widget _users() => Column(children: [
        AdminCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final x in ['Students', 'Tutors', 'Admins'])
              ChoiceChip(
                  label: Text(x),
                  selected:
                      subtab == ['Students', 'Tutors', 'Admins'].indexOf(x),
                  onSelected: (_) => setState(() =>
                      subtab = ['Students', 'Tutors', 'Admins'].indexOf(x)))
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: TextField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search by name, ID, department',
                        isDense: true),
                    onChanged: _studentSource.updateQuery)),
            const SizedBox(width: 10),
            if (canEdit)
              OutlinedButton.icon(
                  onPressed: _import,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Import CSV / Excel')),
            const SizedBox(width: 8),
            if (canEdit)
              FilledButton.icon(
                  onPressed: () => _change(
                      'Bulk reassign tutor',
                      '${selected.length} selected students',
                      'Current advisor assignments',
                      'Selected tutor'),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Reassign tutor'))
          ]),
          const SizedBox(height: 12),
          _studentTable()
        ])),
        const SizedBox(height: 14),
        AdminCard(
            child: const Text(
                'Student eligibility uses 120 points (40 per group); lateral entry uses 90 points (30 per group). Lateral students carry a Lateral tag.',
                style: TextStyle(fontSize: 12, color: AdminColors.muted))),
      ]);

  Future<void> _import() async {
    final files = await FilePicker.pickFiles(
        type: FileType.custom, allowedExtensions: ['csv', 'xlsx', 'xls']);
    if (files.isEmpty) return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${files.first.name} selected for import preview')));
  }

  Widget _studentTable() {
    return SizedBox(
        height: 400,
        child: PaginatedDataTable2(
            rowsPerPage: 5,
            minWidth: 920,
            showCheckboxColumn: true,
            columns: const [
              DataColumn2(label: Text('STUDENT'), size: ColumnSize.L),
              DataColumn2(label: Text('ID')),
              DataColumn2(label: Text('DEPARTMENT')),
              DataColumn2(label: Text('BATCH')),
              DataColumn2(label: Text('POINTS')),
              DataColumn2(label: Text('ELIGIBILITY')),
              DataColumn2(label: Text('ACTIONS'))
            ],
            source: _studentSource));
  }

  Widget _submissions() => Column(children: [
        AdminCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: TextField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search student or activity',
                        isDense: true),
                    onChanged: (v) => setState(() => query = v))),
            const SizedBox(width: 12),
            DropdownButton<String>(
                value: 'All statuses',
                items: const [
                  'All statuses',
                  'Pending',
                  'Flagged',
                  'Approved',
                  'Rejected'
                ]
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (_) => {})
          ]),
          const SizedBox(height: 12),
          SizedBox(
              height: 410,
              child: PaginatedDataTable2(
                  rowsPerPage: 5,
                  minWidth: 900,
                  columns: const [
                    DataColumn2(label: Text('STUDENT')),
                    DataColumn2(label: Text('ACTIVITY')),
                    DataColumn2(label: Text('GROUP')),
                    DataColumn2(label: Text('POINTS')),
                    DataColumn2(label: Text('STATUS')),
                    DataColumn2(label: Text('SUBMITTED')),
                    DataColumn2(label: Text('ACTIONS'))
                  ],
                  source: _submissionSource))
        ])),
        const SizedBox(height: 14),
        AdminCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const AdminSectionTitle('Submission review details',
              subtitle:
                  'Document viewer · OCR fields · detection results · review timeline'),
          const SizedBox(height: 12),
          const Text(
              'Auto-approved certificates are already approved and need no tutor action. Select a pending or flagged submission to inspect its certificate, extracted OCR data, detection results and review timeline.',
              style: TextStyle(color: AdminColors.muted, fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            OutlinedButton.icon(
                onPressed: canEdit
                    ? () => _change('Reopen submission', 'SUB-2024-0182',
                        'Approved', 'Pending review')
                    : null,
                icon: const Icon(Icons.replay),
                label: const Text('Reopen')),
            OutlinedButton.icon(
                onPressed: canEdit
                    ? () => _change('Override points', 'SUB-2024-0182',
                        '10 points', '12 points')
                    : null,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Override points')),
            OutlinedButton.icon(
                onPressed: canEdit
                    ? () => _change('Revoke approval', 'SUB-2024-0182',
                        'Approved', 'Revoked')
                    : null,
                icon: const Icon(Icons.block),
                label: const Text('Revoke'))
          ])
        ]))
      ]);

  Widget _rulebook() => Column(children: [
        AdminCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const AdminSectionTitle('Points and eligibility',
              subtitle: 'Total requirement: 120 points · 40 from each group'),
          const SizedBox(height: 14),
          const Wrap(spacing: 10, runSpacing: 10, children: [
            StatusPill('Group I · 40 pts'),
            StatusPill('Group II · 40 pts', color: Color(0xFF1477AA)),
            StatusPill('Group III · 40 pts', color: Color(0xFF946300)),
            StatusPill('Lateral · 90 pts (30 per group)',
                color: AdminColors.slate)
          ]),
          const SizedBox(height: 14),
          const Text(
              'Group I: NSS/NCC/NSO, arts/sports/games, union/club activities.\nGroup II: English/aptitude proficiency, internship/clinical exposure, conferences, workshops, hackathons.\nGroup III: journal publications, patents, start-ups, innovation, hackathon wins, skilling certificates.',
              style: TextStyle(height: 1.7, fontSize: 12)),
          const SizedBox(height: 12),
          const Text(
              'Approval document codes: a Certificate · b Letter from Authorities · c Appreciation letter · d Documentary evidence · e Legal proof · f Others',
              style: TextStyle(fontSize: 11, color: AdminColors.muted))
        ])),
        const SizedBox(height: 12),
        AdminCard(
            child: Column(children: [
          for (final a in AdminMockData.activities.asMap().entries)
            ListTile(
                dense: true,
                title: Text(a.value, style: const TextStyle(fontSize: 13)),
                subtitle: Text(
                    'Group ${a.key < 3 ? 'I' : a.key < 6 ? 'II' : 'III'} · test rule · max contribution 40 pts'),
                trailing: canEdit
                    ? IconButton(
                        onPressed: () => _change(
                            'Edit rulebook activity',
                            a.value,
                            'Current points: 10',
                            'Updated points: 12'),
                        icon: const Icon(Icons.edit_outlined))
                    : null,
                leading: CircleAvatar(
                    radius: 13,
                    backgroundColor: const Color(0xFFE8F5EE),
                    child: Text(String.fromCharCode(97 + a.key),
                        style: const TextStyle(
                            fontSize: 11, color: AdminColors.greenDark))))
        ]))
      ]);

  Widget _audit() => AdminCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AdminSectionTitle('Audit Log',
            subtitle: 'Read-only record of administrative changes'),
        const SizedBox(height: 14),
        const Wrap(spacing: 8, runSpacing: 8, children: [
          SizedBox(
              width: 250,
              child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search audit entries',
                      isDense: true))),
          StatusPill('All actions'),
          StatusPill('Last 30 days', color: AdminColors.slate)
        ]),
        const SizedBox(height: 12),
        for (final e in audit.entries)
          ExpansionTile(
              title: Text('${e.action} · ${e.target}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${e.actor} · ${e.role} · ${e.timestamp.toLocal()}',
                  style:
                      const TextStyle(fontSize: 11, color: AdminColors.muted)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Before: ${e.oldValue}\nAfter: ${e.newValue}\nReason: ${e.reason}',
                        style: const TextStyle(fontSize: 12, height: 1.6)))
              ]),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Audit export prepared from visible mock entries'))),
            icon: const Icon(Icons.download),
            label: const Text('Export audit log'))
      ]));
}

class _StudentSource extends mui.DataTableSource {
  _StudentSource(this.names, this.role, this.selected,
      {required this.onAction});
  final List<String> names;
  final AdminRole role;
  final Set<int> selected;
  final void Function(String) onAction;
  String _query = '';

  List<String> get _visibleNames => names
      .where((name) => name.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  void updateQuery(String query) {
    _query = query;
    notifyListeners();
  }

  @override
  mui.DataRow? getRow(int index) {
    final visibleNames = _visibleNames;
    if (index >= visibleNames.length) return null;
    final id = index + 1;
    final name = visibleNames[index];
    return DataRow2(
        selected: selected.contains(id),
        onSelectChanged: (v) {
          if (v == true) {
            selected.add(id);
          } else {
            selected.remove(id);
          }
          notifyListeners();
        },
        cells: [
          mui.DataCell(Text(name)),
          mui.DataCell(Text('SJCET24${(id + 100).toString()}')),
          mui.DataCell(Text(index == 0
              ? 'Computer Science & Engineering'
              : 'Electronics & Communication')),
          mui.DataCell(Text(index == 1 ? 'Lateral · S7' : 'S7 · 2024')),
          mui.DataCell(Text('${95 + id * 5} / 120')),
          mui.DataCell(StatusPill(id == 1 ? 'Eligible' : 'In progress',
              color: id == 1 ? AdminColors.greenDark : AdminColors.slate)),
          mui.DataCell(IconButton(
              onPressed: role.canEdit ? () => onAction(name) : null,
              icon: Icon(
                  role.canEdit
                      ? Icons.edit_outlined
                      : Icons.visibility_outlined,
                  size: 18)))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _visibleNames.length;
  @override
  int get selectedRowCount => selected.length;
}

class _SubmissionSource extends mui.DataTableSource {
  _SubmissionSource(this.canEdit, this.act, this.certificates,
      {this.departmentAdmin = false});
  final bool canEdit;
  final void Function(String, String) act;
  final List<Certificate> certificates;
  final bool departmentAdmin;
  List<Certificate> get visibleRows => departmentAdmin
      ? certificates.take(3).toList()
      : certificates;

  String _status(Certificate certificate) => switch (certificate.status) {
        CertificateStatus.pending => 'Pending',
        CertificateStatus.flagged => 'Flagged',
        CertificateStatus.rejected => 'Rejected',
        CertificateStatus.autoApproved || CertificateStatus.reviewed =>
          'Approved',
      };

  String _group(Certificate certificate) => switch (certificate.group) {
        ActivityGroup.groupI => 'I',
        ActivityGroup.groupII => 'II',
        ActivityGroup.groupIII => 'III',
      };

  @override
  mui.DataRow? getRow(int i) {
    final shown = visibleRows;
    if (i >= shown.length) return null;
    final r = shown[i];
    final status = _status(r);
    final col = status == 'Flagged' || status == 'Rejected'
        ? AdminColors.red
        : status == 'Pending'
            ? AdminColors.amber
            : AdminColors.greenDark;
    return mui.DataRow(cells: [
      mui.DataCell(Text(getStudentById(r.studentId)?.name ?? 'Unknown student')),
      mui.DataCell(Text(r.title)),
      mui.DataCell(Text(_group(r))),
      mui.DataCell(Text('${r.pointsAwarded > 0 ? r.pointsAwarded : r.pointsIfTrusted}')),
      mui.DataCell(StatusPill(status, color: col)),
      mui.DataCell(Text(r.uploadDate)),
      mui.DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            tooltip: 'Review details',
            onPressed: () => act(r.title, 'Open submission details'),
            icon: const Icon(Icons.open_in_new, size: 17)),
        if (r.status == CertificateStatus.pending ||
            r.status == CertificateStatus.flagged)
          IconButton(
              tooltip: 'Mark approved',
              onPressed: canEdit ? () => act(r.title, 'Mark submission approved') : null,
              icon: const Icon(Icons.check, size: 17, color: AdminColors.greenDark))
        else
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Approved', style: TextStyle(color: AdminColors.greenDark, fontSize: 12, fontWeight: FontWeight.w600)),
          )
      ]))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => visibleRows.length;
  @override
  int get selectedRowCount => 0;
}
