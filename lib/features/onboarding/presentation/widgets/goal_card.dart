import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/cards/simu_selectable_card.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';

/// Feature-specific Goal Card widget composing [SimuSelectableCard] and [UserGoal].
class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final UserGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SimuSelectableCard(
      title: goal.title,
      description: goal.description,
      isSelected: isSelected,
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: Text(
          goal.iconEmoji,
          style: const TextStyle(fontSize: 22),
        ),
      ),
      badge: SimuBadge(
        text: '+${goal.xpBonus} XP',
        backgroundColor:
            isSelected ? AppColors.accentYellowLight : AppColors.surfaceMuted,
        textColor: isSelected ? AppColors.depthYellow : AppColors.textSecondary,
      ),
    );
  }
}
