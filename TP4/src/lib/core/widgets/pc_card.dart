import 'package:flutter/material.dart';

class PcCard extends StatelessWidget {
  const PcCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final highContrast = theme.brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border:
            border ??
            (highContrast ? Border.all(color: colors.outline, width: 2) : null),
        boxShadow: [
          if (!highContrast)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: child,
    );
  }
}
