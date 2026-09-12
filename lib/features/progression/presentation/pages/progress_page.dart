import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/layout/simu_page_header.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';
import 'package:simu/features/progression/domain/entities/simu_achievement.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Screen — Comprehensive yet playful progress & rewards experience.
class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progression = ref.watch(userProgressionProvider);

    return SimuScaffold(
      bottomAction: SimuPrimaryAction(
        label: 'View Practice History',
        icon: const Icon(LucideIcons.history, color: Colors.white, size: 18),
        onPressed: () => context.push(RouteNames.challengeHistory),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimuPageHeader(
            title: 'My Growth & Stats',
            subtitle: 'Track your simulation mastery and milestone achievements',
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.home);
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Level & XP Hero Card
                  _buildLevelHeroCard(progression),

                  const SizedBox(height: 16),

                  // 2. Weekly Consistency & Streak Tracker
                  _buildStreakTrackerCard(progression),

                  const SizedBox(height: 16),

                  // 3. Core Competencies / Skill Dimensions
                  _buildSkillDimensionsCard(),

                  const SizedBox(height: 16),

                  // 4. Achievements Collection Showcase
                  _buildAchievementsShowcase(context, progression),

                  const SizedBox(height: 16),

                  // 5. Recent Activity Card
                  _buildRecentActivityCard(context, progression),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelHeroCard(UserProgressionState progression) {
    final level = progression.userLevel;
    final currentLevelXp = progression.currentLevelXp;
    final targetXp = progression.nextLevelTargetXp;
    final progress = (currentLevelXp / targetXp).clamp(0.0, 1.0);

    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SimuMascot(
            state: MascotState.celebrating,
            size: 64,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimuBadge(
                      text: 'LEVEL $level',
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    Flexible(
                      child: Text(
                        '${progression.totalXp} Total XP',
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.depthYellow,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Rising Communicator',
                  style: AppTypography.heading3.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                SimuProgressBar(
                  progress: progress,
                  height: 8,
                  fillColor: AppColors.depthYellow,
                  backgroundColor: AppColors.borderLight,
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentLevelXp / $targetXp XP to Level ${level + 1}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakTrackerCard(UserProgressionState progression) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    // Mock: first 3 days active for 3-day streak
    const activeDays = [true, true, true, false, false, false, false];

    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.flame,
                    size: 18,
                    color: Color(0xFFFF5252),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'WEEKLY CONSISTENCY',
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFFFF5252),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SimuBadge(
                text: '${progression.streakDays} DAYS ACTIVE',
                backgroundColor: const Color(0xFFFFECEB),
                textColor: const Color(0xFFFF5252),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isActive = activeDays[index];
              return Column(
                children: [
                  Container(
                    width: 38,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFFF5252)
                          : AppColors.surfaceMuted,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFFFF5252)
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isActive ? LucideIcons.flame : LucideIcons.circle,
                        size: 16,
                        color: isActive ? Colors.white : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[index],
                    style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillDimensionsCard() {
    final skills = [
      ('Clarity & Structure', 0.90, '90%'),
      ('Executive Presence', 0.85, '85%'),
      ('Relevance & Story Hook', 0.88, '88%'),
      ('Composure Under Stress', 0.82, '82%'),
    ];

    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.chartColumn,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'CORE COMPETENCIES',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...skills.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        skill.$1,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        skill.$3,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SimuProgressBar(
                    progress: skill.$2,
                    height: 7,
                    fillColor: AppColors.primary,
                    backgroundColor: AppColors.borderLight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsShowcase(
      BuildContext context, UserProgressionState progression) {
    final achievements = progression.achievements.take(3).toList();

    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.trophy,
                size: 16,
                color: AppColors.depthYellow,
              ),
              const SizedBox(width: 6),
              Text(
                'ACHIEVEMENTS',
                style: AppTypography.caption.copyWith(
                  color: AppColors.depthYellow,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${progression.unlockedAchievementsCount}/${progression.achievements.length} Unlocked',
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...achievements.map((ach) => _AchievementMiniRow(achievement: ach)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => context.push(RouteNames.achievements),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Full Trophy Vault',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronRight,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(
      BuildContext context, UserProgressionState progression) {
    final recent = progression.history.take(2).toList();

    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.history,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'RECENT PRACTICE SESSIONS',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            Text(
              'No practice sessions yet. Start your first challenge today!',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            ...recent.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${item.score}',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.scenarioTitle,
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '+${item.xpEarned} XP • ${item.status.label}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.chevronRight, size: 16),
                      onPressed: () {
                        context.push(
                          RouteNames.simulationResults
                              .replaceAll(':id', item.scenarioId),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AchievementMiniRow extends StatelessWidget {
  const _AchievementMiniRow({required this.achievement});

  final SimuAchievement achievement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: achievement.badgeColor.withValues(alpha: 0.15),
              borderRadius: AppRadii.roundedMd,
            ),
            child: Center(
              child: Text(
                achievement.iconEmoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: achievement.isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                Text(
                  achievement.description,
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SimuBadge(
            text: achievement.isUnlocked
                ? 'UNLOCKED'
                : '${achievement.currentProgress}/${achievement.targetProgress}',
            backgroundColor: achievement.isUnlocked
                ? AppColors.accentGreen.withValues(alpha: 0.15)
                : AppColors.surfaceMuted,
            textColor: achievement.isUnlocked
                ? AppColors.accentGreen
                : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
