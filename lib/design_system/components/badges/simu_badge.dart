import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Pill badge for bonus XP, highlights, tags, and category labels.
class SimuBadge extends StatelessWidget {
  const SimuBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor = AppColors.primaryContainer,
    this.textColor = AppColors.primary,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs + 2,
      vertical: AppSpacing.xxs,
    ),
  });

  final String text;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadii.roundedPill,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            AppSpacing.gapH4,
          ],
          Flexible(
            child: Text(
              text,
              style: AppTypography.badge.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
