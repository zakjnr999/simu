import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Top header for Onboarding Screen containing the Skip pill button on the right,
/// and an optional premium back arrow button on the left (visible from Step 2 onwards).
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.onSkip,
    this.onBack,
    this.currentStep = 1,
  });

  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onBack != null)
            _TactileCircleIconButton(
              onPressed: onBack!,
              icon: LucideIcons.arrowLeft,
            )
          else
            const SizedBox(width: 36, height: 39),

          _TactileSkipButton(onPressed: onSkip),
        ],
      ),
    );
  }
}

/// Circular back control with the same tactile press feel as onboarding CTAs.
class _TactileCircleIconButton extends StatefulWidget {
  const _TactileCircleIconButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  State<_TactileCircleIconButton> createState() =>
      _TactileCircleIconButtonState();
}

class _TactileCircleIconButtonState extends State<_TactileCircleIconButton> {
  bool _isPressed = false;
  static const double _size = 36;
  static const double _depthHeight = 3;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: _size,
          height: _size + _depthHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: _depthHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D3EA),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: AppMotion.durationFast,
                curve: AppMotion.curveDecelerate,
                top: _isPressed ? _depthHeight : 0,
                left: 0,
                right: 0,
                bottom: _isPressed ? 0 : _depthHeight,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: const Color(0xFF7551FF),
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

/// Skip pill with tactile press animation and arrow icon.
class _TactileSkipButton extends StatefulWidget {
  const _TactileSkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_TactileSkipButton> createState() => _TactileSkipButtonState();
}

class _TactileSkipButtonState extends State<_TactileSkipButton> {
  bool _isPressed = false;
  static const double _depthHeight = 3;

  @override
  Widget build(BuildContext context) {
    const skipContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Skip',
            style: TextStyle(
              fontFamily: AppTypography.bodyFontFamily,
              color: Color(0xFF37364D),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 6),
          Icon(
            LucideIcons.arrowRight,
            size: 18,
            color: Color(0xFF7551FF),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      label: 'Skip',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 36 + _depthHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Opacity(opacity: 0, child: skipContent),
              Positioned(
                top: _depthHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D3EA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              AnimatedPositioned(
                duration: AppMotion.durationFast,
                curve: AppMotion.curveDecelerate,
                top: _isPressed ? _depthHeight : 0,
                left: 0,
                right: 0,
                bottom: _isPressed ? 0 : _depthHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: skipContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
