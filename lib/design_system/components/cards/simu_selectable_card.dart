import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_shadows.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Interactive selectable card with tactile border, selected tint, and checkmark indicator.
class SimuSelectableCard extends StatelessWidget {
  const SimuSelectableCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.description,
    this.leading,
    this.badge,
    this.isEnabled = true,
  });

  final String title;
  final String? description;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? badge;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      enabled: isEnabled,
      label: title,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: AppMotion.durationNormal,
          curve: AppMotion.curveStandard,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceHighlight : AppColors.surface,
            borderRadius: AppRadii.roundedLg,
            border: Border.all(
              color: isSelected ? AppColors.borderActive : AppColors.border,
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: isSelected ? AppShadows.glowPrimary : AppShadows.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                AppSpacing.gapH16,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.heading3.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          AppSpacing.gapH8,
                          badge!,
                        ],
                      ],
                    ),
                    if (description != null) ...[
                      AppSpacing.gapV4,
                      Text(
                        description!,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.gapH12,
              // Indicator Checkmark Circle
              AnimatedContainer(
                duration: AppMotion.durationFast,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        LucideIcons.check,
                        size: 15,
                        color: AppColors.textOnPrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
