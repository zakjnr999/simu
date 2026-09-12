import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';

/// Minimal indeterminate loading state with mascot context.
class SimuLoadingState extends StatelessWidget {
  const SimuLoadingState({
    super.key,
    this.message = 'Loading your practice arena...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SimuMascot(
              state: MascotState.thinking,
              size: 96,
            ),
            AppSpacing.gapV24,
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            AppSpacing.gapV16,
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
