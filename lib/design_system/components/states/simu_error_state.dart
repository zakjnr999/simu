import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';

/// Minimal error state with failure description and retry action.
class SimuErrorState extends StatelessWidget {
  const SimuErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SimuMascot(
              state: MascotState.disappointed,
              size: 96,
            ),
            AppSpacing.gapV24,
            const Text(
              'Oops! Something went wrong',
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapV8,
            Text(
              message,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.accentCoral),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapV24,
              SimuPrimaryAction(
                label: retryLabel,
                onPressed: onRetry,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
