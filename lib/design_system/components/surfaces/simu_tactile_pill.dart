import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_motion.dart';

/// Compact pill surface with onboarding-style tactile press depth.
class SimuTactilePill extends StatefulWidget {
  const SimuTactilePill({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = radius,
    this.semanticsLabel,
    this.semanticsButton = false,
  });

  static const double radius = 16;
  static const double depthHeight = 3;
  static const Color depthColor = Color(0xFFE5DDD0);

  static BoxDecoration get surfaceDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: const Color(0xFFEFE8DD),
          width: 1.5,
        ),
      );

  static BoxDecoration raisedSurfaceDecoration(double borderRadius) =>
      surfaceDecoration.copyWith(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      );

  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final String? semanticsLabel;
  final bool semanticsButton;

  @override
  State<SimuTactilePill> createState() => _SimuTactilePillState();
}

class _SimuTactilePillState extends State<SimuTactilePill> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final content = widget.child;

    return Semantics(
      button: widget.semanticsButton,
      label: widget.semanticsLabel,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: IntrinsicHeight(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: SimuTactilePill.depthHeight),
                child: Opacity(opacity: 0, child: content),
              ),
              Positioned(
                top: SimuTactilePill.depthHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: SimuTactilePill.depthColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              AnimatedPositioned(
                duration: AppMotion.durationFast,
                curve: AppMotion.curveDecelerate,
                top: _isPressed ? SimuTactilePill.depthHeight : 0,
                left: 0,
                right: 0,
                bottom: _isPressed ? 0 : SimuTactilePill.depthHeight,
                child: DecoratedBox(
                  decoration: SimuTactilePill.raisedSurfaceDecoration(
                    widget.borderRadius,
                  ),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
