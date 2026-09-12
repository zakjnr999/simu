import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/features/journey/domain/entities/milestone_challenge.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';

/// Interactive challenge tile in PracticeDetailPage supporting Start & Replay actions.
class PracticeChallengeTile extends StatelessWidget {
  const PracticeChallengeTile({
    super.key,
    required this.challenge,
    required this.onStart,
    this.isReplayable = false,
  });

  final MilestoneChallenge challenge;
  final VoidCallback onStart;
  final bool isReplayable;

  @override
  Widget build(BuildContext context) {
    final isCompleted = challenge.isCompleted;
    final isLocked = challenge.isLocked;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OnboardingTactileSurface(
        showOuterShadow: false,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.accentGreen.withValues(alpha: 0.15)
                        : (isLocked
                            ? AppColors.surfaceMuted
                            : AppColors.primaryContainer),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.accentGreen
                          : (isLocked
                              ? AppColors.border
                              : AppColors.primaryLight),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isCompleted
                          ? LucideIcons.check
                          : (isLocked ? LucideIcons.lock : LucideIcons.play),
                      size: 17,
                      color: isCompleted
                          ? AppColors.accentGreen
                          : (isLocked
                              ? AppColors.textTertiary
                              : AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isLocked
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.description,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SimuBadge(
                  text: '${challenge.durationMinutes} MIN',
                  backgroundColor: AppColors.surfaceMuted,
                  textColor: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                SimuBadge(
                  text: challenge.difficulty.toUpperCase(),
                  backgroundColor: AppColors.surfaceMuted,
                  textColor: AppColors.textSecondary,
                ),
                const Spacer(),
                SimuBadge(
                  text: '+${challenge.xpReward} XP',
                  backgroundColor: AppColors.accentYellowLight,
                  textColor: AppColors.depthYellow,
                ),
              ],
            ),
            if (!isLocked) ...[
              const SizedBox(height: 12),
              SimuPrimaryAction(
                label: isCompleted ? 'Replay Practice' : 'Start Challenge',
                icon: Icon(
                  isCompleted ? LucideIcons.rotateCcw : LucideIcons.play,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: onStart,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
