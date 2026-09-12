import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/journey/domain/entities/journey_milestone.dart';
import 'package:simu/features/journey/domain/entities/milestone_challenge.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';

/// Modal bottom sheet displaying detailed milestone information and its challenges.
class MilestoneDetailSheet extends StatelessWidget {
  const MilestoneDetailSheet({
    super.key,
    required this.milestone,
    required this.milestoneIndex,
    required this.totalMilestones,
  });

  final JourneyMilestone milestone;
  final int milestoneIndex;
  final int totalMilestones;

  static void show(
    BuildContext context, {
    required JourneyMilestone milestone,
    required int milestoneIndex,
    required int totalMilestones,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MilestoneDetailSheet(
        milestone: milestone,
        milestoneIndex: milestoneIndex,
        totalMilestones: totalMilestones,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x331E1B4B),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadii.roundedPill,
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SimuBadge(
                            text: 'CHAPTER $milestoneIndex OF $totalMilestones',
                            backgroundColor: AppColors.primaryContainer,
                            textColor: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          SimuBadge(
                            text: '+${milestone.xpReward} XP',
                            backgroundColor: AppColors.accentYellowLight,
                            textColor: AppColors.depthYellow,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        milestone.title,
                        style: AppTypography.heading2.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.borderLight),

          // Content body
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Chapter Overview Card
                  OnboardingTactileSurface(
                    showOuterShadow: false,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHAPTER OBJECTIVE',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          milestone.description.isNotEmpty
                              ? milestone.description
                              : 'Master this core competency through guided simulations and feedback.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SimuProgressBar(
                                progress: milestone.progressRatio,
                                height: 8,
                                fillColor: AppColors.accentGreen,
                                backgroundColor: AppColors.borderLight,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${milestone.completedChallengeCount}/${milestone.challenges.length} Done',
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 2. Challenge List Header
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.sparkles,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'CHALLENGES IN THIS CHAPTER',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 3. Challenge items
                  if (milestone.challenges.isEmpty)
                    _buildFallbackChallengeTile(context)
                  else
                    ...milestone.challenges.map(
                      (challenge) => _ChallengeCard(
                        challenge: challenge,
                        onStart: () {
                          Navigator.of(context).pop();
                          final targetId = challenge.scenarioId ??
                              'interview-tell-me-about-yourself';
                          context.push(
                            RouteNames.simulationIntro
                                .replaceAll(':id', targetId),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackChallengeTile(BuildContext context) {
    return _ChallengeCard(
      challenge: MilestoneChallenge(
        id: 'fallback_chal',
        title: milestone.title,
        description: 'Interactive practice simulation with expert AI partner.',
        durationMinutes: 8,
        xpReward: milestone.xpReward,
        difficulty: milestone.difficulty.label,
        isCompleted: milestone.isCompleted,
        isLocked: milestone.isLocked,
        scenarioId: 'interview-tell-me-about-yourself',
      ),
      onStart: () {
        Navigator.of(context).pop();
        context.push(
          RouteNames.simulationIntro
              .replaceAll(':id', 'interview-tell-me-about-yourself'),
        );
      },
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.onStart,
  });

  final MilestoneChallenge challenge;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final isLocked = challenge.isLocked;
    final isCompleted = challenge.isCompleted;

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
                // Status icon circle
                Container(
                  width: 36,
                  height: 36,
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
                      size: 16,
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
                          fontSize: 14,
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
                label: isCompleted ? 'Practice Again' : 'Start Challenge',
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
