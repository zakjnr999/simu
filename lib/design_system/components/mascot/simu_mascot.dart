import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';

/// Pluggable renderer contract for the Simu mascot.
///
/// Allows swapping the underlying rendering engine (vector, PNG, Lottie, Rive)
/// without changing any screen code or component APIs.
abstract class MascotRenderer {
  Widget buildMascot(BuildContext context, MascotState state, double size);
}

/// Default Corgi mascot renderer providing clean asset resolution and a delightful
/// visual fallback representing the Simu Corgi identity.
class DefaultCorgiMascotRenderer implements MascotRenderer {
  const DefaultCorgiMascotRenderer();

  String _assetForState(MascotState state) {
    return switch (state) {
      MascotState.idle => 'assets/mascot/corgi_idle.png',
      MascotState.happy => 'assets/mascot/corgi_happy.png',
      MascotState.encouraging => 'assets/mascot/corgi_encouraging.png',
      MascotState.thinking => 'assets/mascot/corgi_thinking.png',
      MascotState.celebrating => 'assets/mascot/corgi_celebrating.png',
      MascotState.disappointed => 'assets/mascot/corgi_disappointed.png',
      MascotState.speaking => 'assets/mascot/corgi_speaking.png',
    };
  }

  @override
  Widget buildMascot(BuildContext context, MascotState state, double size) {
    // Tries to load asset if available; otherwise displays the clean Corgi identity illustration
    return Image.asset(
      _assetForState(state),
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        return _CorgiFallbackIllustration(state: state, size: size);
      },
    );
  }
}

/// Reusable Simu mascot component.
///
/// Screens consume this component with a [MascotState] and [size].
/// The internal rendering logic delegates to a pluggable [MascotRenderer].
class SimuMascot extends StatelessWidget {
  const SimuMascot({
    super.key,
    this.state = MascotState.idle,
    this.size = 120,
    this.renderer = const DefaultCorgiMascotRenderer(),
  });

  final MascotState state;
  final double size;
  final MascotRenderer renderer;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.durationNormal,
      switchInCurve: AppMotion.curveStandard,
      switchOutCurve: AppMotion.curveStandard,
      child: KeyedSubtree(
        key: ValueKey(state),
        child: renderer.buildMascot(context, state, size),
      ),
    );
  }
}

/// Clean, delightful fallback illustration representing the Simu Corgi mascot.
class _CorgiFallbackIllustration extends StatelessWidget {
  const _CorgiFallbackIllustration({
    required this.state,
    required this.size,
  });

  final MascotState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Friendly expressions for fallback Corgi avatar
    final (expressionEmoji, expressionColor) = switch (state) {
      MascotState.idle => ('🐶', AppColors.primaryLight),
      MascotState.happy => ('🐶✨', AppColors.accentYellow),
      MascotState.encouraging => ('🐾🐶', AppColors.accentGreen),
      MascotState.thinking => ('💭🐶', AppColors.accentSky),
      MascotState.celebrating => ('🎉🐶🎉', AppColors.accentCoral),
      MascotState.disappointed => ('🥺', AppColors.textTertiary),
      MascotState.speaking => ('💬🐶', AppColors.primary),
    };

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceCream,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: expressionColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: size < 90
          ? Center(
              child: Text(
                expressionEmoji,
                style: TextStyle(
                  fontSize: (size * 0.45).clamp(12.0, 42.0),
                  height: 1.0,
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  expressionEmoji,
                  style: TextStyle(
                    fontSize: (size * 0.36).clamp(16.0, 48.0),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadii.roundedPill,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Text(
                    'Simu Corgi',
                    style: TextStyle(
                      fontFamily: AppTypography.displayFontFamily,
                      fontSize: (size * 0.09).clamp(7.0, 11.0),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
