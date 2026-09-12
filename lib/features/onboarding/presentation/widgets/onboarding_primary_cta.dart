import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Glossy 3D primary action button: "Let's Begin the Journey!" or "Continue My Journey"
///
/// Refined to support dynamic text and optional left-aligned graphics (e.g. Step 2 yellow flag).
class OnboardingPrimaryCta extends StatefulWidget {
  const OnboardingPrimaryCta({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = "Let's Begin the Journey!",
    this.leftWidget,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final Widget? leftWidget;

  @override
  State<OnboardingPrimaryCta> createState() => _OnboardingPrimaryCtaState();
}

class _OnboardingPrimaryCtaState extends State<OnboardingPrimaryCta> {
  bool _isPressed = false;
  static const double _depthHeight = 5.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.text,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.isLoading ? null : widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Bottom 3D Bevel/Depth Shadow Layer (Deep Violet-Purple)
              Positioned(
                top: _depthHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B1BA3),
                    borderRadius: AppRadii.roundedPill,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x356A35FF),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Main Tactile Action Surface Layer (No solid border line)
              AnimatedPositioned(
                duration: AppMotion.durationFast,
                curve: AppMotion.curveDecelerate,
                top: _isPressed ? _depthHeight : 0,
                left: 0,
                right: 0,
                bottom: _isPressed ? 0 : _depthHeight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF5A31F4),
                        Color(0xFF884BFD),
                      ],
                    ),
                    borderRadius: AppRadii.roundedPill,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Subtly Glossy/Specular Highlight Overlay on top half of the pill
                      Positioned(
                        top: 1.5,
                        left: 2,
                        right: 2,
                        height: 22,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x59FFFFFF),
                                Color(0x00FFFFFF),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),

                      // Button Content
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left widget or placeholder spacer
                          widget.leftWidget ?? const SizedBox(width: 40),

                          // Centered Text Copy
                          Expanded(
                            child: Text(
                              widget.isLoading
                                  ? 'Loading...'
                                  : widget.text,
                              textAlign: TextAlign.center,
                              style: AppTypography.buttonLarge.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),

                          // Right Circular White Arrow Disc
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x18000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.arrowRight,
                              size: 20,
                              color: Color(0xFF6F32FA),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
