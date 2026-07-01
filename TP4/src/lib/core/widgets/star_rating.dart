import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    this.size = 14,
    this.onChanged,
  });

  final int value;
  final double size;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final active = index < value;
        final icon = Icon(
          active ? Icons.star : Icons.star_border,
          size: size,
          color: AppColors.accent,
        );
        if (onChanged == null) return icon;
        return GestureDetector(onTap: () => onChanged!(index + 1), child: icon);
      }),
    );
  }
}
