import 'package:flutter/material.dart';

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
    final image = url.startsWith('assets/')
        ? Image.asset(
            url,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: _buildError,
          )
        : Image.network(
            url,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: _buildError,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: width,
      color: colors.primary.withValues(alpha: 0.10),
      child: Icon(
        Icons.directions_boat_filled_outlined,
        color: colors.primary,
        size: 34,
      ),
    );
  }
}
