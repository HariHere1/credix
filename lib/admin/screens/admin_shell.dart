import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../admin_theme.dart';
import '../admin_router.dart';
import '../models/admin_user.dart';
import '../models/admin_session.dart';
import '../mock_data/admin_mock_data.dart';
import '../widgets/admin_card.dart';
import 'dashboard_screen.dart';
import 'module_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.section, this.recordId});
  final String section;
  final String? recordId;
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  AdminUser get user => AdminSession.instance.user!;
  int get selected => items.indexWhere((item)=>item.label==widget.section).clamp(0, items.length-1);
  static const items = <_NavItem>[
    _NavItem('Dashboard', Icons.grid_view_rounded), _NavItem('Users', Icons.people_alt_outlined),
    _NavItem('Submissions', Icons.fact_check_outlined, badge: '${AdminMockData.adminAttention}'), _NavItem('Rulebook', Icons.menu_book_outlined),
    _NavItem('Reports', Icons.auto_graph_rounded, later: true), _NavItem('Audit Log', Icons.history_rounded),
    _NavItem('Detection Settings', Icons.document_scanner_outlined, later: true), _NavItem('Announcements', Icons.campaign_outlined, later: true),
    _NavItem('Academic Year', Icons.calendar_month_outlined, later: true), _NavItem('System Settings', Icons.tune_rounded, later: true),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, size) {
        final compact = size.maxWidth < 1100;
        return Scaffold(body: Row(children: [
          Container(width: compact ? 76 : 260, color: Colors.white, child: Column(children: [
            Padding(padding: EdgeInsets.all(compact ? 16 : 22), child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/brand/credix_logo.png', width: 34, height: 34, fit: BoxFit.cover)), if (!compact) const Padding(padding: EdgeInsets.only(left: 10), child: Text('CREDIX', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.4)))])),
            if (!compact) const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 6), child: Align(alignment: Alignment.centerLeft, child: Text('NAVIGATION', style: TextStyle(fontSize: 10, letterSpacing: .6, color: AdminColors.muted, fontWeight: FontWeight.w700)))),
            Expanded(child: ListView(padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 9), children: [for (var i=0; i<items.length; i++) _nav(i, compact)])),
            if (!compact) Padding(padding: const EdgeInsets.all(9), child: AdminCard(padding: const EdgeInsets.all(11), child: Row(children: [const CircleAvatar(radius: 16, backgroundColor: AdminColors.greenDark, child: Icon(Icons.person, color: Colors.white, size: 17)), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), Text(user.role.label, style: const TextStyle(fontSize: 11, color: AdminColors.greenDark))]))]))),
          ])),
          Expanded(child: Column(children: [
            _topbar(compact),
            Expanded(child: selected == 0 ? const DashboardScreen() : ModuleScreen(section: items[selected].label, user: user)),
          ])),
        ]));
      });

  Widget _nav(int i, bool compact) {
    final item = items[i]; final active = selected == i;
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Tooltip(message: item.label, child: InkWell(onTap: () => adminGo(context,item.label), borderRadius: BorderRadius.circular(12), child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 10), decoration: BoxDecoration(color: active ? AdminColors.green : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: compact ? MainAxisAlignment.center : MainAxisAlignment.start, children: [Icon(item.icon, size: 18, color: active ? Colors.white : const Color(0xFF405047)), if (!compact) ...[const SizedBox(width: 10), Expanded(child: Text(item.label, style: TextStyle(fontSize: 13, color: active ? const Color(0xFF063C20) : const Color(0xFF405047), fontWeight: active ? FontWeight.w600 : FontWeight.w400))), if (item.badge != null) StatusPill(item.badge!, color: AdminColors.red)]])))));
  }

  Widget _topbar(bool compact) => Container(height: 64, padding: const EdgeInsets.symmetric(horizontal: 24), decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AdminColors.border))), child: Row(children: [Expanded(child: Container(height: 38, constraints: const BoxConstraints(maxWidth: 390), padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: const Color(0xFFF4F6F7), borderRadius: BorderRadius.circular(24)), child: const Row(children: [Icon(Icons.search, size: 18, color: AdminColors.muted), SizedBox(width: 9), Text('Search students, submissions, rules…', style: TextStyle(fontSize: 12, color: AdminColors.muted))]))), if (!compact) const StatusPill('SJCET Palai 2024 Scheme'), const SizedBox(width: 12), if (user.role == AdminRole.auditor) const StatusPill('READ ONLY', color: AdminColors.slate), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)), PopupMenuButton<String>(icon: const CircleAvatar(radius: 16, backgroundColor: AdminColors.greenDark, child: Icon(Icons.person_outline, color: Colors.white, size: 17)), itemBuilder: (_) => [PopupMenuItem(value: 'role', child: Text(user.role.label)), const PopupMenuItem(value: 'logout', child: Text('Sign out'))], onSelected: (v) { if (v == 'logout') { AdminSession.instance.signOut(); context.go('/login'); } })]));
}

class _NavItem { const _NavItem(this.label, this.icon, {this.badge, this.later=false}); final String label; final IconData icon; final String? badge; final bool later; }
