import 'package:flutter/material.dart';

import '../admin_theme.dart';

class AdminCard extends StatelessWidget {
  const AdminCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: padding, child: child));
}

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle(this.title, {super.key, this.subtitle, this.trailing});
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AdminColors.ink)), if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 3), child: Text(subtitle!, style: const TextStyle(fontSize: 12, color: AdminColors.muted)))])), if (trailing != null) trailing!]);
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.color = AdminColors.greenDark});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => DecoratedBox(decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700))));
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, required this.value, required this.note, required this.icon, this.color = AdminColors.greenDark});
  final String title, value, note;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => AdminCard(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .5, color: AdminColors.muted))), Icon(icon, size: 18, color: color)]), const SizedBox(height: 18), Text(value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(note, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))]));
}
