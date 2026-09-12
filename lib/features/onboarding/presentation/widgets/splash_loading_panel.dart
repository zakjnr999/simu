import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';

/// Floating bottom loading panel for the Splash Screen matching the approved tactile 3D reference.
///
/// Features:
/// - Tactile 3D card with physical bottom extruded bevel and warm ambient depth shadow
/// - Soft ceramic surface with subtle top specular highlight gradient and creamy border
/// - Deeply recessed 3D groove channel housing the candy-striped progress bar
/// - Bold purple percentage display in Fredoka
/// - Centered 3-paw milestone indicators using the 3D glossy paw asset
class SplashLoadingPanel extends StatelessWidget {
  const SplashLoadingPanel({
    super.key,
    required this.progress,
    this.statusMessage = 'Preparing your adventure...',
  });

  /// Real initialization progress value from 0.0 to 1.0.
  final double progress;

  /// Current initialization status message.
  final String statusMessage;

  static const double _cardDepthHeight = 5.0;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentage = (clampedProgress * 100).toInt();

    return Semantics(
      label: 'Loading progress: $percentage percent. $statusMessage',
      value: '$percentage%',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Bottom 3D Depth Layer (Physical extruded lip + warm ambient drop shadow)
            Positioned(
              top: _cardDepthHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFE2D0B6), // warm sandy-clay bottom bevel
                  borderRadius: BorderRadius.circular(38),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x353E2004),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Top Tactile Surface Layer
            Container(
              margin: const EdgeInsets.only(bottom: _cardDepthHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF), // crisp specular highlight rim
                    Color(0xFFFFFDF8),
                    Color(0xFFFFF7EB), // warm light cream base
                  ],
                  stops: [0.0, 0.3, 1.0],
                ),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: const Color(0xFFFAF3E5),
                  width: 2.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Centered Status Message
                  AnimatedSwitcher(
                    duration: AppMotion.durationFast,
                    child: Text(
                      statusMessage,
                      key: ValueKey(statusMessage),
                      textAlign: TextAlign.center,
                      style: AppTypography.heading3.copyWith(
                        color: const Color(0xFF262456),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar Row: 3D Recessed Channel on left + Percentage on right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SimuProgressBar(
                          progress: clampedProgress,
                          height: 20,
                          isStriped: true,
                          fillColor: const Color(0xFF7551FF),
                          fillHighlightColor: const Color(0xFF8E6BFF),
                          depthColor: const Color(0xFF4F27D4),
                          backgroundColor: const Color(0xFFF7EFE5),
                          grooveTopColor: const Color(0xFFDECBB6),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '$percentage%',
                        style: AppTypography.xp.copyWith(
                          color: const Color(0xFF7551FF),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Centered 3 Paw Milestone Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final milestoneThreshold =
                          (index + 1) / 3.0; // 0.33, 0.66, 1.0
                      final isReached =
                          clampedProgress >= milestoneThreshold - 0.05;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: AnimatedOpacity(
                          duration: AppMotion.durationNormal,
                          curve: AppMotion.curveStandard,
                          opacity: isReached ? 1.0 : 0.28,
                          child: AnimatedScale(
                            duration: AppMotion.durationNormal,
                            curve: AppMotion.curveStandard,
                            scale: isReached ? 1.05 : 0.95,
                            child: Image.asset(
                              'assets/icons/paw_icon.png',
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  '🐾',
                                  style: TextStyle(fontSize: 18),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
