import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Tactile secondary outline / ghost button.
class SimuSecondaryAction extends StatefulWidget {
  const SimuSecondaryAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isEnabled = true,
    this.borderColor = AppColors.border,
    this.textColor = AppColors.textPrimary,
    this.height = 52,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isEnabled;
  final Color borderColor;
  final Color textColor;
  final double height;
  final bool fullWidth;

  @override
  State<SimuSecondaryAction> createState() => _SimuSecondaryActionState();
}

class _SimuSecondaryActionState extends State<SimuSecondaryAction> {
  bool _isPressed = false;

  bool get _canInteract => widget.isEnabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        widget.isEnabled ? widget.textColor : AppColors.textTertiary;
    final effectiveBorderColor =
        widget.isEnabled ? widget.borderColor : AppColors.borderLight;

    final child = Semantics(
      button: true,
      enabled: _canInteract,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) =>
            _canInteract ? setState(() => _isPressed = true) : null,
        onTapUp: (_) =>
            _canInteract ? setState(() => _isPressed = false) : null,
        onTapCancel: () =>
            _canInteract ? setState(() => _isPressed = false) : null,
        onTap: _canInteract ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: AppMotion.durationFast,
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isPressed ? AppColors.surfaceMuted : AppColors.surface,
            borderRadius: AppRadii.roundedLg,
            border: Border.all(
              color: effectiveBorderColor,
              width: 1.5,
            ),
          ),
          child: Padding(
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
                    style: AppTypography.buttonLarge.copyWith(
                      color: effectiveTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.fullWidth) {
      return SizedBox(width: double.infinity, child: child);
    }
    return child;
  }
}
