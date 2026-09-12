import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';

/// Tactile candy-style rounded progress bar with 3D recessed groove, extruded fill,
/// and animated diagonal stripes (lashes).
class SimuProgressBar extends StatefulWidget {
  const SimuProgressBar({
    super.key,
    required this.progress,
    this.height = 18,
    this.backgroundColor = const Color(0xFFF4ECE2),
    this.grooveTopColor = const Color(0xFFDFCCB8),
    this.fillColor = const Color(0xFF7551FF),
    this.fillHighlightColor = const Color(0xFF8E6DFF),
    this.depthColor = const Color(0xFF4F28D6),
    this.isStriped = false,
    this.animateStripes = true,
  });

  /// Value between 0.0 and 1.0.
  final double progress;
  final double height;
  final Color backgroundColor;
  final Color grooveTopColor;
  final Color fillColor;
  final Color fillHighlightColor;
  final Color depthColor;
  final bool isStriped;
  final bool animateStripes;

  @override
  State<SimuProgressBar> createState() => _SimuProgressBarState();
}

class _SimuProgressBarState extends State<SimuProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _stripeController;

  @override
  void initState() {
    super.initState();
    if (widget.isStriped && widget.animateStripes) {
      _stripeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      )..repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SimuProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isStriped &&
        widget.animateStripes &&
        _stripeController == null) {
      _stripeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      )..repeat();
    } else if (!widget.animateStripes && _stripeController != null) {
      _stripeController?.stop();
    }
  }

  @override
  void dispose() {
    _stripeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedProgress = widget.progress.clamp(0.0, 1.0);
    final stripeController = _stripeController;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.grooveTopColor,
            widget.backgroundColor,
          ],
        ),
        borderRadius: AppRadii.roundedPill,
        border: Border.all(
          color: widget.grooveTopColor.withValues(alpha: 0.7),
          width: 1.5,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final targetWidth = constraints.maxWidth * clampedProgress;

          return Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: targetWidth),
              duration: AppMotion.durationNormal,
              curve: AppMotion.curveStandard,
              builder: (context, width, child) {
                if (width <= 0) return const SizedBox.shrink();

                final bottomDepthHeight =
                    (widget.height * 0.22).clamp(2.5, 4.0);

                return Container(
                  width: width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: widget.depthColor,
                    borderRadius: AppRadii.roundedPill,
                  ),
                  child: Stack(
                    children: [
                      // 3D Top Surface Capsule
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: bottomDepthHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.fillHighlightColor,
                                widget.fillColor,
                              ],
                            ),
                            borderRadius: AppRadii.roundedPill,
                          ),
                          child: ClipRRect(
                            borderRadius: AppRadii.roundedPill,
                            child: widget.isStriped
                                ? (stripeController != null
                                    ? AnimatedBuilder(
                                        animation: stripeController,
                                        builder: (context, _) {
                                          return CustomPaint(
                                            size: Size(width, widget.height),
                                            painter: _CandyStripePainter(
                                              stripeOffset:
                                                  stripeController.value * 24.0,
                                            ),
                                          );
                                        },
                                      )
                                    : const CustomPaint(
                                        painter: _CandyStripePainter(
                                          stripeOffset: 0,
                                        ),
                                      ))
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter to draw clean, diagonal candy-cane style stripes (lashes).
class _CandyStripePainter extends CustomPainter {
  const _CandyStripePainter({required this.stripeOffset});

  final double stripeOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x32FFFFFF)
      ..style = PaintingStyle.fill;

    const stripeWidth = 8.0;
    const stripeSpacing = 16.0;
    const step = stripeWidth + stripeSpacing;

    final slant = size.height * math.tan(math.pi / 4); // 45 degree angle

    final startX = -size.height - step + (stripeOffset % step);
    final endX = size.width + step;

    for (double x = startX; x < endX; x += step) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + slant, 0)
        ..lineTo(x + slant + stripeWidth, 0)
        ..lineTo(x + stripeWidth, size.height)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CandyStripePainter oldDelegate) {
    return oldDelegate.stripeOffset != stripeOffset;
  }
}
