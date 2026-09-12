import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_shadows.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Comic-style speech / thought bubble for mascot messages and dialogues.
class SimuMascotBubble extends StatelessWidget {
  const SimuMascotBubble({
    super.key,
    required this.message,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.textColor = AppColors.textPrimary,
  });

  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.durationNormal,
      switchInCurve: AppMotion.curveStandard,
      switchOutCurve: AppMotion.curveStandard,
      child: Container(
        key: ValueKey(message),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadii.roundedLg,
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: AppShadows.card,
        ),
        child: Text(
          message,
          style: AppTypography.titleSmall.copyWith(
            color: textColor,
            height: 1.35,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
