import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PcButtonVariant { primary, secondary, outline, ghost, danger, teal }

class PcButton extends StatelessWidget {
  const PcButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = PcButtonVariant.primary,
    this.full = false,
    this.loading = false,
    this.small = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final PcButtonVariant variant;
  final bool full;
  final bool loading;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final style = _styleFor(context, variant);
    final foreground = enabled
        ? style.foreground
        : style.foreground.withValues(alpha: 0.45);
    final background = enabled
        ? style.background
        : style.background.withValues(alpha: 0.45);

    return SizedBox(
      width: full ? double.infinity : null,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(small ? 14 : 18),
          side: BorderSide(
            color: enabled
                ? style.border
                : style.border.withValues(alpha: 0.35),
            width: style.borderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: small ? 13 : 18,
              vertical: small ? 9 : 13,
            ),
            child: Row(
              mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  SizedBox(
                    width: small ? 14 : 18,
                    height: small ? 14 : 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foreground,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: small ? 15 : 18, color: foreground),
                if (loading || icon != null) const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w800,
                      fontSize: small ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ButtonStyle _styleFor(BuildContext context, PcButtonVariant variant) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.dark) {
      final colors = theme.colorScheme;
      return switch (variant) {
        PcButtonVariant.primary ||
        PcButtonVariant.secondary ||
        PcButtonVariant.teal => _ButtonStyle(
          colors.primary,
          colors.onPrimary,
          colors.primary,
          2,
        ),
        PcButtonVariant.outline ||
        PcButtonVariant.ghost ||
        PcButtonVariant.danger => _ButtonStyle(
          colors.surface,
          colors.primary,
          colors.primary,
          2,
        ),
      };
    }

    return switch (variant) {
      PcButtonVariant.primary => const _ButtonStyle(
        AppColors.primary,
        Colors.white,
        AppColors.primary,
        0,
      ),
      PcButtonVariant.secondary => const _ButtonStyle(
        AppColors.secondary,
        Colors.white,
        AppColors.secondary,
        0,
      ),
      PcButtonVariant.outline => const _ButtonStyle(
        Colors.white,
        AppColors.primary,
        AppColors.primary,
        1.5,
      ),
      PcButtonVariant.ghost => const _ButtonStyle(
        Colors.transparent,
        AppColors.primary,
        Colors.transparent,
        0,
      ),
      PcButtonVariant.danger => const _ButtonStyle(
        AppColors.danger,
        Colors.white,
        AppColors.danger,
        0,
      ),
      PcButtonVariant.teal => const _ButtonStyle(
        AppColors.teal,
        Colors.white,
        AppColors.teal,
        0,
      ),
    };
  }
}

class _ButtonStyle {
  const _ButtonStyle(
    this.background,
    this.foreground,
    this.border,
    this.borderWidth,
  );

  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;
}
