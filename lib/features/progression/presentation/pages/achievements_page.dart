import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/layout/simu_page_header.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';
import 'package:simu/features/progression/domain/entities/simu_achievement.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Screen — Gamified Achievement Vault displaying earned badges, progress, and rewards.
class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({super.key});

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage> {
  AchievementCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final progression = ref.watch(userProgressionProvider);
    final achievements = progression.achievements;

    final filtered = _selectedCategory == null
        ? achievements
        : achievements.where((a) => a.category == _selectedCategory).toList();

    final unlockedCount = progression.unlockedAchievementsCount;
    final totalCount = achievements.length;
    final progressRatio =
        totalCount > 0 ? (unlockedCount / totalCount).clamp(0.0, 1.0) : 0.0;

    return SimuScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimuPageHeader(
            title: 'Achievement Vault',
            subtitle: 'Unlock badges, claim XP, and celebrate your milestones',
            onBack: () => context.pop(),
          ),

          // 1. Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All ($totalCount)',
                  isSelected: _selectedCategory == null,
                  onSelected: () => setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: 8),
                ...AchievementCategory.values.map((cat) {
                  final count =
                      achievements.where((a) => a.category == cat).length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      label: '${cat.label} ($count)',
                      isSelected: _selectedCategory == cat,
                      onSelected: () => setState(() => _selectedCategory = cat),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // 2. Achievements List
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                // Top Progress Summary Card
                _buildVaultSummaryCard(
                  unlockedCount: unlockedCount,
                  totalCount: totalCount,
                  progressRatio: progressRatio,
                ),

                const SizedBox(height: 16),

                // Achievements List
                ...filtered.map(
                  (achievement) => _AchievementCard(achievement: achievement),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ActionChip(
      label: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: 1.5,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedPill),
      onPressed: onSelected,
    );
  }

  Widget _buildVaultSummaryCard({
    required int unlockedCount,
    required int totalCount,
    required double progressRatio,
  }) {
    return OnboardingTactileSurface(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SimuMascot(
            state: MascotState.celebrating,
            size: 60,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SimuBadge(
                      text: 'TROPHY VAULT',
                      backgroundColor: AppColors.accentYellowLight,
                      textColor: AppColors.depthYellow,
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        '$unlockedCount of $totalCount Unlocked',
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SimuProgressBar(
                  progress: progressRatio,
                  height: 8,
                  fillColor: AppColors.accentGreen,
                  backgroundColor: AppColors.borderLight,
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep practicing to unlock rare and legendary badges!',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final SimuAchievement achievement;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OnboardingTactileSurface(
        showOuterShadow: false,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Achievement Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? achievement.badgeColor.withValues(alpha: 0.18)
                        : AppColors.surfaceMuted,
                    borderRadius: AppRadii.roundedMd,
                    border: Border.all(
                      color: isUnlocked
                          ? achievement.badgeColor.withValues(alpha: 0.5)
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      achievement.iconEmoji,
                      style: TextStyle(
                        fontSize: 24,
                        color: isUnlocked ? null : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SimuBadge(
                            text: achievement.category.label.toUpperCase(),
                            backgroundColor: AppColors.surfaceMuted,
                            textColor: AppColors.textSecondary,
                          ),
                          const Spacer(),
                          SimuBadge(
                            text: '+${achievement.xpReward} XP',
                            backgroundColor: AppColors.accentYellowLight,
                            textColor: AppColors.depthYellow,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        achievement.title,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
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
                Expanded(
                  child: SimuProgressBar(
                    progress: achievement.progressRatio,
                    height: 6,
                    fillColor: isUnlocked
                        ? AppColors.accentGreen
                        : AppColors.primary,
                    backgroundColor: AppColors.borderLight,
                  ),
                ),
                const SizedBox(width: 12),
                SimuBadge(
                  text: isUnlocked
                      ? 'UNLOCKED'
                      : '${achievement.currentProgress} / ${achievement.targetProgress}',
                  backgroundColor: isUnlocked
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : AppColors.surfaceMuted,
                  textColor: isUnlocked
                      ? AppColors.accentGreen
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
