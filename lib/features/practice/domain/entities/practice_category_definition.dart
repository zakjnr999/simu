import 'package:flutter/material.dart';
import 'package:simu/features/journey/domain/entities/milestone_challenge.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';

/// Domain entity defining a practice category in the Simu Practice Library.
class PracticeCategoryDefinition {
  const PracticeCategoryDefinition({
    required this.category,
    required this.title,
    required this.tagline,
    required this.description,
    required this.skillsPracticed,
    required this.difficulty,
    required this.estimatedMinutesPerSession,
    required this.iconEmoji,
    required this.accentColor,
    required this.accentBgColor,
    this.iconAsset,
    this.challenges = const [],
    this.totalMilestones = 4,
    this.isLocked = false,
  });

  final UserGoalCategory category;
  final String title;
  final String tagline;
  final String description;
  final List<String> skillsPracticed;
  final ChallengeDifficulty difficulty;
  final int estimatedMinutesPerSession;
  final String iconEmoji;
  final Color accentColor;
  final Color accentBgColor;
  final String? iconAsset;
  final List<MilestoneChallenge> challenges;
  final int totalMilestones;
  final bool isLocked;

  int get totalXpPotential =>
      challenges.fold(0, (sum, c) => sum + c.xpReward);

  int get totalChallenges => challenges.length;
}
