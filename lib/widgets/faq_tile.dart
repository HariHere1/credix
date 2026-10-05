import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'section_header.dart';

/// A compact "Frequently asked" accordion section for dashboards.
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  static const _items = [
    (
      'How do I upload a certificate?',
      'Open the Certificates tab, tap Upload, choose a PDF/JPG/PNG file, pick the activity type, and submit. It goes to pending review.',
    ),
    (
      'How are points calculated?',
      'Points come from the activity rulebook, capped at 40 per group. Group I, II and III max out, with 120 total for the year.',
    ),
    (
      'How does advisor review work?',
      'Advisors get a review queue of flagged certificates. They can Approve, Correct & Approve, or Reject each one, which updates the student\'s points and status.',
    ),
    (
      'Can I re-upload after rejection?',
      'Yes. Submit a corrected certificate from the Certificates tab; it creates a new pending entry linked to your activity.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: "FAQ's"),
        const SizedBox(height: AppSpacing.md),
        for (final item in _items) FaqTile(question: item.$1, answer: item.$2),
      ],
    );
  }
}

class FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  const FaqTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        question,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      iconColor: AppColors.accent,
      collapsedIconColor: AppColors.textSecondary,
      visualDensity: VisualDensity.compact,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            answer,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
          ),
        ),
      ],
    );
  }
}
