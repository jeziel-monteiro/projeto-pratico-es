import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProgressSteps extends StatelessWidget {
  const ProgressSteps({super.key, required this.labels, required this.current});

  final List<String> labels;
  final int current;

  @override
  Widget build(BuildContext context) {
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
                      ? AppColors.primary
                      : complete
                      ? AppColors.success
                      : const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: complete
                    ? const Icon(Icons.check, size: 15, color: Colors.white)
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: active ? Colors.white : AppColors.muted,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
              ),
              const SizedBox(height: 5),
              Text(
                labels[index],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.muted,
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
