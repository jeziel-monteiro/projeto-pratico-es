import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.borderRadius = 18,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: AppColors.primary.withValues(alpha: 0.10),
            child: const Icon(
              Icons.directions_boat_filled_outlined,
              color: AppColors.primary,
              size: 34,
            ),
          );
        },
      ),
    );
  }
}
