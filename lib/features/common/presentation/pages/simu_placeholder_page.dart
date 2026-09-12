import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_secondary_action.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';

/// Minimal placeholder page for unimplemented routes.
///
/// Only displays the route name, provides a simple Back navigation action,
/// and contains no invented product UI.
class SimuPlaceholderPage extends StatelessWidget {
  const SimuPlaceholderPage({
    super.key,
    required this.routeName,
  });

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SimuScaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Route: $routeName',
                style: AppTypography.heading2,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapV8,
              Text(
                'This screen will be built in the next incremental phase.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomAction: SimuSecondaryAction(
        label: 'Back',
        icon: const Icon(LucideIcons.arrowLeft, size: 20),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
    );
  }
}
