import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';

/// Standard header for Simu pages with back navigation, optional step progress,
/// title, and subtitle.
class SimuPageHeader extends StatelessWidget {
  const SimuPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.currentStep,
    this.totalSteps,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final int? currentStep;
  final int? totalSteps;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final hasProgress =
        currentStep != null && totalSteps != null && totalSteps! > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Back button, Progress bar / Trailing
          Row(
            children: [
              if (onBack != null)
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: const Icon(
                      LucideIcons.arrowLeft,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                )
              else
                const SizedBox(width: 36),
              if (hasProgress) ...[
                AppSpacing.gapH12,
                Expanded(
                  child: SimuProgressBar(
                    progress: currentStep! / totalSteps!,
                  ),
                ),
                AppSpacing.gapH12,
                Text(
                  '$currentStep/$totalSteps',
                  style: AppTypography.badge
                      .copyWith(color: AppColors.textSecondary),
                ),
              ] else
                const Spacer(),
              if (trailing != null) ...[
                AppSpacing.gapH8,
                trailing!,
              ],
            ],
          ),
          AppSpacing.gapV16,
          // Title
          Text(
            title,
            style: AppTypography.heading1,
          ),
          if (subtitle != null) ...[
            AppSpacing.gapV8,
            Text(
              subtitle!,
              style: AppTypography.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}
