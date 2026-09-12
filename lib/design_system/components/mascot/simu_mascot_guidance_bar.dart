import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_bubble.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';

/// Reusable coach bar uniting Ace the mascot and a speech bubble with standardized spacing.
class SimuMascotGuidanceBar extends StatelessWidget {
  const SimuMascotGuidanceBar({
    super.key,
    required this.message,
    this.mascotState = MascotState.encouraging,
    this.mascotSize = 48,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColors.primaryLight,
    this.textColor = AppColors.textPrimary,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.trailing,
  });

  final String message;
  final MascotState mascotState;
  final double mascotSize;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SimuMascot(
          state: mascotState,
          size: mascotSize,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SimuMascotBubble(
            message: message,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            textColor: textColor,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          trailing!,
        ],
      ],
    );
  }
}
