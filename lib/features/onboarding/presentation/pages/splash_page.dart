import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/core/bootstrap/app_bootstrap_service.dart';
import 'package:simu/core/bootstrap/splash_timing.dart';
import 'package:simu/features/onboarding/presentation/widgets/splash_loading_panel.dart';

/// Screen 1 — Splash Screen.
///
/// Runs real startup work (storage, fonts, image precache) while the loading
/// panel reflects actual progress.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  String _statusMessage = 'Preparing your adventure...';
  AppBootstrapResult? _bootstrapResult;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _runBootstrap());
  }

  Future<void> _runBootstrap() async {
    final startedAt = DateTime.now();
    if (kDebugMode) {
      debugPrint('[Bootstrap][Splash] bootstrap scheduled');
    }

    final bootstrap = ref.read(appBootstrapServiceProvider);

    _bootstrapResult = await bootstrap.run(
      context: context,
      onProgress: _handleBootstrapProgress,
    );

    final elapsed = DateTime.now().difference(startedAt);
    final minDisplayDuration = ref.read(splashMinDisplayDurationProvider);
    final remaining = minDisplayDuration - elapsed;

    if (kDebugMode) {
      debugPrint(
        '[Bootstrap][Splash] bootstrap finished in ${elapsed.inMilliseconds}ms '
        '(images=${_bootstrapResult!.imageSuccessCount}/${_bootstrapResult!.imageTotal} '
        'failed=${_bootstrapResult!.imageFailCount} fonts=${_bootstrapResult!.fontCount})',
      );
    }

    if (remaining > Duration.zero) {
      if (kDebugMode) {
        debugPrint(
          '[Bootstrap][Splash] waiting min display ${remaining.inMilliseconds}ms',
        );
      }
      await Future<void>.delayed(remaining);
    }

    if (!mounted) {
      return;
    }

    _progressController.value = 1;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) {
      return;
    }

    final result = _bootstrapResult;
    if (result == null) {
      return;
    }

    final route =
        result.onboardingComplete ? RouteNames.home : RouteNames.welcome;
    if (kDebugMode) {
      debugPrint('[Bootstrap][Splash] navigate → $route');
    }

    context.go(route);
  }

  void _handleBootstrapProgress(double progress, String message) {
    if (!mounted) {
      return;
    }

    setState(() => _statusMessage = message);
    _progressController.value = progress.clamp(0, 1);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/illustrations/splash/splash_background.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.background,
                alignment: Alignment.center,
                child: const Text('Simu', style: TextStyle(fontSize: 32)),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return SplashLoadingPanel(
                      progress: _progressController.value,
                      statusMessage: _statusMessage,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
