import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/app/router/app_router.dart';
import 'package:simu/app/theme/app_theme.dart';
import 'package:simu/core/constants/app_constants.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_curtain_transition.dart';

/// Root application widget for Simu.
class SimuApp extends ConsumerWidget {
  const SimuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.topLeft,
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            if (child != null) child,
            const Positioned.fill(
              child: TickerMode(
                enabled: true,
                child: OnboardingCurtainTransitionOverlay(
                  key: ValueKey('curtain-overlay'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
