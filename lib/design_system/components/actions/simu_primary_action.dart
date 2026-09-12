import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Tactile 3D primary action button.
///
/// Features a physical press-depth micro-animation, prominent bottom border depth,
/// and support for loading state.
class SimuPrimaryAction extends StatefulWidget {
  const SimuPrimaryAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor = AppColors.primary,
    this.depthColor = AppColors.depthPrimary,
    this.textColor = AppColors.textOnPrimary,
    this.height = 56,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isEnabled;
  final Color backgroundColor;
  final Color depthColor;
  final Color textColor;
  final double height;
  final bool fullWidth;

  @override
  State<SimuPrimaryAction> createState() => _SimuPrimaryActionState();
}

class _SimuPrimaryActionState extends State<SimuPrimaryAction> {
  bool _isPressed = false;

  static const double _depthHeight = 4.0;

  bool get _canInteract =>
      widget.isEnabled && !widget.isLoading && widget.onPressed != null;

  void _onTapDown(TapDownDetails details) {
    if (_canInteract) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_canInteract) {
      setState(() => _isPressed = false);
    }
  }

  void _onTapCancel() {
    if (_canInteract) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor =
        widget.isEnabled ? widget.backgroundColor : AppColors.border;
    final effectiveDepthColor =
        widget.isEnabled ? widget.depthColor : AppColors.depthSecondary;
    final effectiveTextColor =
        widget.isEnabled ? widget.textColor : AppColors.textTertiary;

    final child = Semantics(
      button: true,
      enabled: _canInteract,
      label: widget.label,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _canInteract ? widget.onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom 3D Depth Layer
              Positioned(
                top: _depthHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: effectiveDepthColor,
                    borderRadius: AppRadii.roundedLg,
                  ),
                ),
              ),
              // Top Action Surface Layer
              AnimatedPositioned(
                duration: AppMotion.durationFast,
                curve: AppMotion.curveDecelerate,
                top: _isPressed ? _depthHeight : 0,
                left: 0,
                right: 0,
                bottom: _isPressed ? 0 : _depthHeight,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: effectiveBgColor,
                    borderRadius: AppRadii.roundedLg,
                    boxShadow: widget.isEnabled && !_isPressed
                        ? [
                            BoxShadow(
                              color: widget.backgroundColor
                                  .withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: widget.isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                effectiveTextColor),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                widget.icon!,
                                AppSpacing.gapH8,
                              ],
                              Flexible(
                                child: Text(
                                  widget.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.buttonLarge.copyWith(
                                    color: effectiveTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: child,
      );
    }
    return child;
  }
}
