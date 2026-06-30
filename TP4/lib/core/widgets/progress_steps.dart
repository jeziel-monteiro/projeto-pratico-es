import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProgressSteps extends StatelessWidget {
  const ProgressSteps({super.key, required this.labels, required this.current});

  final List<String> labels;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final highContrast = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(labels.length, (index) {
        final complete = index < current;
        final active = index == current;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: active
                      ? colors.primary
                      : complete
                      ? (highContrast ? colors.primary : AppColors.success)
                      : colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: complete
                    ? Icon(Icons.check, size: 15, color: colors.onPrimary)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: active
                              ? colors.onPrimary
                              : colors.onSurfaceVariant,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
              ),
              const SizedBox(height: 5),
              Text(
                labels[index],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
