import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';

/// Ace coach hint banner at the bottom or top of the conversation stream.
class SimulationCoachBar extends StatelessWidget {
  const SimulationCoachBar({
    super.key,
    required this.coachTip,
    required this.isVisible,
    required this.onToggle,
  });

  final String coachTip;
  final bool isVisible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceCream,
                borderRadius: AppRadii.roundedPill,
                border: Border.all(
                  color: AppColors.accentYellowLight,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    "Show Ace's Tip",
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFF5D4037),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SimuMascotGuidanceBar(
        message: coachTip,
        mascotSize: 42,
        mascotState: MascotState.encouraging,
        backgroundColor: AppColors.surfaceCream,
        borderColor: AppColors.accentYellowLight,
        textColor: const Color(0xFF5D4037),
        crossAxisAlignment: CrossAxisAlignment.end,
        trailing: GestureDetector(
          onTap: onToggle,
          child: const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Icon(
              LucideIcons.x,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
