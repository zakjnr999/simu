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
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/features/journey/domain/journey_configs.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';
import 'package:simu/features/practice/domain/entities/practice_category_definition.dart';
import 'package:simu/features/practice/presentation/providers/practice_provider.dart';
import 'package:simu/features/practice/presentation/widgets/practice_challenge_tile.dart';

/// Screen — Reusable Practice Detail experience for any practice category.
class PracticeDetailPage extends ConsumerWidget {
  const PracticeDetailPage({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = UserGoalCategory.values.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => UserGoalCategory.interviews,
    );

    final summary = ref.watch(practiceCategoryProvider(category));
    final def = summary.definition;
    final journey = JourneyConfigs.forCategory(category);
    final challenges = def.challenges;

    final nextAvailableChallenge = challenges.firstWhere(
      (c) => !c.isLocked && !c.isCompleted,
      orElse: () => challenges.first,
    );

    return SimuScaffold(
      bottomAction: SimuPrimaryAction(
        label: nextAvailableChallenge.isCompleted
            ? 'Replay Challenge'
            : 'Start Challenge',
        icon: Icon(
          nextAvailableChallenge.isCompleted
              ? LucideIcons.rotateCcw
              : LucideIcons.play,
          color: Colors.white,
          size: 18,
        ),
        onPressed: () {
          final targetScenarioId = nextAvailableChallenge.scenarioId ??
              'interview-tell-me-about-yourself';
          context.push(
            RouteNames.simulationIntro.replaceAll(':id', targetScenarioId),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header
          SimuPageHeader(
            title: def.title,
            subtitle: def.tagline,
            onBack: () => context.pop(),
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                // 2. Hero Overview Card
                _buildOverviewCard(def, summary.isPrimary, journey),

                const SizedBox(height: 16),

                // 3. Ace Coach Tip
                _buildAceAdvice(def),

                const SizedBox(height: 16),

                // 4. Skills Practiced Section
                _buildSkillsSection(def),

                const SizedBox(height: 20),

                // 5. Challenges Section
                Row(
                  children: [
                    const Icon(
                      LucideIcons.sparkles,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AVAILABLE CHALLENGES (${challenges.length})',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...challenges.map(
                  (challenge) => PracticeChallengeTile(
                    challenge: challenge,
                    isReplayable: challenge.isCompleted,
                    onStart: () {
                      final scenarioId = challenge.scenarioId ??
                          'interview-tell-me-about-yourself';
                      context.push(
                        RouteNames.simulationIntro
                            .replaceAll(':id', scenarioId),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    PracticeCategoryDefinition def,
    bool isPrimary,
    JourneyDefinition journey,
  ) {
    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: def.accentBgColor,
                  borderRadius: AppRadii.roundedMd,
                  border: Border.all(
                    color: def.accentColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    def.iconEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (isPrimary)
                          const SimuBadge(
                            text: 'YOUR PRIMARY GOAL',
                            backgroundColor: Color(0xFFF1EFFF),
                            textColor: AppColors.primary,
                          ),
                        SimuBadge(
                          text: def.difficulty.label.toUpperCase(),
                          backgroundColor: AppColors.surfaceMuted,
                          textColor: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      def.title,
                      style: AppTypography.heading3.copyWith(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            def.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SimuBadge(
                text: '${def.estimatedMinutesPerSession} MIN SESSIONS',
                backgroundColor: AppColors.surfaceMuted,
                textColor: AppColors.textSecondary,
              ),
              SimuBadge(
                text: '${journey.milestones.length} CHAPTERS',
                backgroundColor: AppColors.surfaceMuted,
                textColor: AppColors.textSecondary,
              ),
              SimuBadge(
                text: '+${def.totalXpPotential} XP',
                backgroundColor: AppColors.accentYellowLight,
                textColor: AppColors.depthYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAceAdvice(PracticeCategoryDefinition def) {
    return const SimuMascotGuidanceBar(
      mascotSize: 46,
      message:
          'Practice as many times as you like! Each session refines your reflexes and builds XP.',
    );
  }

  Widget _buildSkillsSection(PracticeCategoryDefinition def) {
    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.target,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'TARGET COMPETENCIES',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: def.skillsPracticed.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: AppRadii.roundedPill,
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Text(
                  skill,
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
