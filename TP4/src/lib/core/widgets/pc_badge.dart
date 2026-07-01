import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PcBadgeTone { blue, orange, teal, red, gray, green }

class PcBadge extends StatelessWidget {
  const PcBadge({super.key, required this.label, this.tone = PcBadgeTone.blue});

  final String label;
  final PcBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      PcBadgeTone.blue => (
        AppColors.primary.withValues(alpha: 0.10),
        AppColors.primary,
      ),
      PcBadgeTone.orange => (
        AppColors.accent.withValues(alpha: 0.18),
        const Color(0xFFB77900),
      ),
      PcBadgeTone.teal => (
        AppColors.teal.withValues(alpha: 0.12),
        AppColors.teal,
      ),
      PcBadgeTone.red => (const Color(0xFFFFE4E9), AppColors.danger),
      PcBadgeTone.gray => (const Color(0xFFF3F4F6), AppColors.muted),
      PcBadgeTone.green => (const Color(0xFFDFF7EC), const Color(0xFF047857)),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: colors.$2,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
