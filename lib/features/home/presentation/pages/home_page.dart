import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/core/services/user/user_display_name_provider.dart';
import 'package:simu/features/home/presentation/widgets/home_header_bar.dart';
import 'package:simu/features/home/presentation/widgets/home_hero_section.dart';
import 'package:simu/features/home/presentation/widgets/home_level_progress_card.dart';
import 'package:simu/features/home/presentation/widgets/home_todays_challenge_card.dart';
import 'package:simu/features/home/presentation/widgets/home_your_progress_card.dart';
import 'package:simu/features/journey/domain/entities/journey_milestone.dart';
import 'package:simu/features/journey/domain/journey_configs.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Main Simu home tab — hub after onboarding.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const String backgroundAsset = 'assets/illustrations/home/home_bg.png';

  static const Map<String, String> _challengeDescriptions = {
    'Tell Me About Yourself':
        'Practice your self-introduction and make a strong impression.',
    'The First Impression':
        'Make a confident opening that sets the tone for your interview.',
    'Speak Clearly': 'Build clarity and presence in everyday conversations.',
    'Active Listening': 'Practice listening skills that strengthen connection.',
    'Know Your Worth': 'Prepare to advocate for yourself with confidence.',
    'Explain Your Approach': 'Walk through your thinking with clarity.',
  };

  static JourneyMilestone _todayChallengeFor(UserGoalCategory category) {
    final journey = JourneyConfigs.byCategory[category]!;
    final milestones = journey.milestones;

    for (final milestone in milestones) {
      if (!milestone.isLocked && !milestone.isActive) {
        return milestone;
      }
    }

    return milestones.length > 1 ? milestones[1] : milestones.first;
  }

  static String _descriptionFor(JourneyMilestone milestone) {
    return _challengeDescriptions[milestone.title] ??
        'Practice real-world scenarios that build your skills.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingControllerProvider);
    final progression = ref.watch(userProgressionProvider);
    final totalXp = progression.totalXp;
    final displayName =
        ref.watch(userDisplayNameProvider).valueOrNull ?? 'Friend';
    final category =
        onboarding.selectedGoal?.category ?? UserGoalCategory.interviews;
    final practiceLabel =
        '${onboarding.selectedGoal?.title ?? 'Interview'} Practice';
    final todayChallenge = _todayChallengeFor(category);
    final journey = JourneyConfigs.byCategory[category]!;
    final totalMilestones = journey.milestones.length;
    final completedMilestones =
        journey.milestones.where((m) => !m.isLocked).length;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHeaderBar(
            totalXp: totalXp,
            unreadNotificationCount: 3,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: HomeHeroSection(displayName: displayName),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HomeLevelProgressCard(
                              level: 5,
                              title: 'Rising Communicator',
                              currentXp: 350,
                              targetXp: 600,
                              onRewardTap: () =>
                                  context.push(RouteNames.progress),
                            ),
                            const SizedBox(height: 6),
                            HomeTodaysChallengeCard(
                              title: todayChallenge.title,
                              categoryLabel: practiceLabel,
                              description: _descriptionFor(todayChallenge),
                              xpReward: todayChallenge.xpReward,
                              illustrationAsset: todayChallenge.iconAssetPath,
                              onStartChallenge: () {
                                final String scenarioId;
                                switch (category) {
                                  case UserGoalCategory.interviews:
                                    scenarioId = 'interview-tell-me-about-yourself';
                                    break;
                                  case UserGoalCategory.communication:
                                    scenarioId = 'communication-speak-clearly';
                                    break;
                                  case UserGoalCategory.negotiation:
                                    scenarioId = 'negotiation-respond-to-low-offer';
                                    break;
                                  case UserGoalCategory.technical:
                                    scenarioId = 'technical-clarify-requirements';
                                    break;
                                }
                                context.push(
                                  RouteNames.simulationIntro.replaceAll(':id', scenarioId),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            HomeYourProgressCard(
                              practiceLabel: practiceLabel,
                              completedMilestones: completedMilestones,
                              totalMilestones: totalMilestones,
                              totalXp: totalXp,
                              onViewJourneyTap: () =>
                                  context.go(RouteNames.journeyHub),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
