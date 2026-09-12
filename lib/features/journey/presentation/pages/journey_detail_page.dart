import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/home/presentation/widgets/home_header_bar.dart';
import 'package:simu/features/journey/domain/entities/journey_milestone.dart';
import 'package:simu/features/journey/domain/journey_configs.dart';
import 'package:simu/features/journey/presentation/widgets/milestone_detail_sheet.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Screen — Interactive Journey Detail allowing users to explore their path,
/// inspect milestone chapters, and start challenges.
class JourneyDetailPage extends ConsumerWidget {
  const JourneyDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingControllerProvider);
    final progression = ref.watch(userProgressionProvider);
    final category =
        onboarding.selectedGoal?.category ?? UserGoalCategory.interviews;
    final journey = JourneyConfigs.byCategory[category]!;
    final milestones = journey.milestones;

    final completedCount = milestones
        .where((m) =>
            m.isCompleted || progression.completedMilestones.contains(m.id))
        .length;
    final totalCount = milestones.length;
    final overallProgress =
        totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;

    final activeMilestone = milestones.firstWhere(
      (m) => !m.isCompleted && !m.isLocked,
      orElse: () => milestones.first,
    );

    return SimuScaffold(
      bottomAction: SimuPrimaryAction(
        label: 'Continue Chapter: ${activeMilestone.title}',
        icon: const Icon(LucideIcons.play, color: Colors.white, size: 18),
        onPressed: () {
          MilestoneDetailSheet.show(
            context,
            milestone: activeMilestone,
            milestoneIndex: milestones.indexOf(activeMilestone) + 1,
            totalMilestones: totalCount,
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. App Header with XP & Notifications
          HomeHeaderBar(
            totalXp: progression.totalXp,
            unreadNotificationCount: 2,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2. Journey Header Card
                  _buildJourneyHeroBanner(
                    context,
                    categoryTitle:
                        '${onboarding.selectedGoal?.title ?? 'Interview'} Journey',
                    completedCount: completedCount,
                    totalCount: totalCount,
                    progress: overallProgress,
                    streakDays: progression.streakDays,
                  ),

                  const SizedBox(height: 16),

                  // 3. Ace Coach Advice Bar
                  _buildAceCoachingBar(activeMilestone.title),

                  const SizedBox(height: 20),

                  // 4. Milestone Timeline / Path
                  Text(
                    'MILESTONE ROADMAP',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...List.generate(milestones.length, (index) {
                    final milestone = milestones[index];
                    final isCompleted = milestone.isCompleted ||
                        progression.completedMilestones.contains(milestone.id);
                    final isCurrent = milestone.id == activeMilestone.id;
                    final isLast = index == milestones.length - 1;

                    return _MilestoneTimelineItem(
                      index: index + 1,
                      milestone: milestone,
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      isLast: isLast,
                      onTap: () {
                        MilestoneDetailSheet.show(
                          context,
                          milestone: milestone,
                          milestoneIndex: index + 1,
                          totalMilestones: totalCount,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyHeroBanner(
    BuildContext context, {
    required String categoryTitle,
    required int completedCount,
    required int totalCount,
    required double progress,
    required int streakDays,
  }) {
    return OnboardingTactileSurface(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryTitle,
                      style: AppTypography.heading2.copyWith(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedCount of $totalCount Milestones Completed',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SimuBadge(
                text: '$streakDays-Day Streak 🔥',
                backgroundColor: const Color(0xFFFFECEB),
                textColor: const Color(0xFFFF5252),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SimuProgressBar(
            progress: progress,
            height: 10,
            fillColor: AppColors.accentGreen,
            backgroundColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }

  Widget _buildAceCoachingBar(String activeMilestoneTitle) {
    return SimuMascotGuidanceBar(
      message:
          'You are currently tackling "$activeMilestoneTitle"! Tap any milestone to inspect its challenges.',
    );
  }
}

class _MilestoneTimelineItem extends StatelessWidget {
  const _MilestoneTimelineItem({
    required this.index,
    required this.milestone,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.onTap,
  });

  final int index;
  final JourneyMilestone milestone;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Timeline marker column
          SizedBox(
            width: 44,
            child: Column(
              children: [
                // Circle Node
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.accentGreen
                          : (isCurrent
                              ? AppColors.primary
                              : AppColors.surfaceMuted),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primaryLight
                            : (isCompleted
                                ? AppColors.accentGreen
                                : AppColors.border),
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              LucideIcons.check,
                              size: 18,
                              color: Colors.white,
                            )
                          : (milestone.isLocked && !isCurrent
                              ? const Icon(
                                  LucideIcons.lock,
                                  size: 16,
                                  color: AppColors.textTertiary,
                                )
                              : Text(
                                  '$index',
                                  style: AppTypography.heading3.copyWith(
                                    fontSize: 15,
                                    color: isCurrent
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                )),
                    ),
                  ),
                ),
                // Connector Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.accentGreen
                            : AppColors.borderLight,
                        borderRadius: AppRadii.roundedPill,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 2. Milestone Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: onTap,
                child: OnboardingTactileSurface(
                  showOuterShadow: false,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SimuBadge(
                            text: 'CHAPTER $index',
                            backgroundColor: isCurrent
                                ? AppColors.primaryContainer
                                : AppColors.surfaceMuted,
                            textColor: isCurrent
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const Spacer(),
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
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: milestone.isLocked && !isCurrent
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        milestone.description.isNotEmpty
                            ? milestone.description
                            : 'Practice key scenarios to advance your mastery.',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            isCompleted
                                ? LucideIcons.circleCheck
                                : (isCurrent
                                    ? LucideIcons.play
                                    : LucideIcons.lock),
                            size: 13,
                            color: isCompleted
                                ? AppColors.accentGreen
                                : (isCurrent
                                    ? AppColors.primary
                                    : AppColors.textTertiary),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted
                                ? 'Completed'
                                : (isCurrent ? 'In Progress' : 'Locked'),
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isCompleted
                                  ? AppColors.accentGreen
                                  : (isCurrent
                                      ? AppColors.primary
                                      : AppColors.textTertiary),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Inspect >',
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
