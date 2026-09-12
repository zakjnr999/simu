import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/progression/domain/entities/practice_history_item.dart';
import 'package:simu/features/progression/domain/entities/simu_achievement.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';
import 'package:simu/features/simulation/domain/entities/xp_reward.dart';

/// Presentation state for the user's gamified progression.
class UserProgressionState {
  const UserProgressionState({
    required this.baseOnboardingXp,
    this.completedScenarios = const {},
    this.completedMilestones = const {'interviews_1'},
    this.rewardHistory = const [],
    this.history = const [],
    this.achievements = const [],
    this.streakDays = 3,
  });

  final int baseOnboardingXp;
  final Set<String> completedScenarios;
  final Set<String> completedMilestones;
  final List<XPReward> rewardHistory;
  final List<PracticeHistoryItem> history;
  final List<SimuAchievement> achievements;
  final int streakDays;

  int get totalXp {
    final earned = rewardHistory.fold<int>(0, (sum, r) => sum + r.amount);
    return baseOnboardingXp + earned;
  }

  int get userLevel => (totalXp ~/ 100) + 1;
  int get currentLevelXp => totalXp % 100;
  int get nextLevelTargetXp => 100;

  int get unlockedAchievementsCount =>
      achievements.where((a) => a.isUnlocked).length;

  UserProgressionState copyWith({
    int? baseOnboardingXp,
    Set<String>? completedScenarios,
    Set<String>? completedMilestones,
    List<XPReward>? rewardHistory,
    List<PracticeHistoryItem>? history,
    List<SimuAchievement>? achievements,
    int? streakDays,
  }) {
    return UserProgressionState(
      baseOnboardingXp: baseOnboardingXp ?? this.baseOnboardingXp,
      completedScenarios: completedScenarios ?? this.completedScenarios,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      rewardHistory: rewardHistory ?? this.rewardHistory,
      history: history ?? this.history,
      achievements: achievements ?? this.achievements,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

final userProgressionProvider =
    StateNotifierProvider<UserProgressionNotifier, UserProgressionState>((ref) {
  final onboardingXp =
      ref.watch(onboardingControllerProvider).totalOnboardingXp;
  return UserProgressionNotifier(onboardingXp);
});

class UserProgressionNotifier extends StateNotifier<UserProgressionState> {
  UserProgressionNotifier(int baseOnboardingXp)
      : super(
          UserProgressionState(
            baseOnboardingXp: baseOnboardingXp,
            history: _initialHistory,
            achievements: _initialAchievements,
          ),
        );

  static final List<PracticeHistoryItem> _initialHistory = [
    PracticeHistoryItem(
      id: 'hist_01',
      scenarioId: 'interview-tell-me-about-yourself',
      scenarioTitle: 'Tell Me About Yourself',
      category: ChallengeCategory.interviews,
      score: 88,
      xpEarned: 180,
      completedAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: PracticeHistoryStatus.completed,
      headline: 'Impressive Poise & Structure!',
      strengthsCount: 3,
      growthCount: 2,
    ),
    PracticeHistoryItem(
      id: 'hist_02',
      scenarioId: 'communication-speak-clearly',
      scenarioTitle: 'Explain a Difficult Idea Simply',
      category: ChallengeCategory.communication,
      score: 82,
      xpEarned: 150,
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: PracticeHistoryStatus.replayable,
      headline: 'Clear Technical Translation & Empathy',
      strengthsCount: 3,
      growthCount: 2,
    ),
    PracticeHistoryItem(
      id: 'hist_03',
      scenarioId: 'interview-first-impression',
      scenarioTitle: 'The First Impression Warmup',
      category: ChallengeCategory.interviews,
      score: 91,
      xpEarned: 150,
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: PracticeHistoryStatus.completed,
      headline: 'Outstanding Warmth & Confidence',
      strengthsCount: 3,
      growthCount: 1,
    ),
  ];

  static final List<SimuAchievement> _initialAchievements = [
    const SimuAchievement(
      id: 'ach_first_steps',
      category: AchievementCategory.milestones,
      title: 'First Step Forward',
      description: 'Complete your very first live simulation practice.',
      iconEmoji: '🚀',
      badgeColor: Color(0xFF6C5CE7),
      xpReward: 50,
      currentProgress: 1,
      targetProgress: 1,
      isUnlocked: true,
    ),
    const SimuAchievement(
      id: 'ach_structure_master',
      category: AchievementCategory.mastery,
      title: 'Story Architect',
      description: 'Use the Present-Past-Future structure in 3 simulations.',
      iconEmoji: '📐',
      badgeColor: Color(0xFFFF9F43),
      xpReward: 100,
      currentProgress: 2,
      targetProgress: 3,
      isUnlocked: false,
    ),
    const SimuAchievement(
      id: 'ach_streak_hero',
      category: AchievementCategory.streaks,
      title: 'Consistency Champion',
      description: 'Maintain a practice streak of 3 consecutive days.',
      iconEmoji: '🔥',
      badgeColor: Color(0xFFFF5252),
      xpReward: 120,
      currentProgress: 3,
      targetProgress: 3,
      isUnlocked: true,
    ),
    const SimuAchievement(
      id: 'ach_high_performer',
      category: AchievementCategory.mastery,
      title: 'Executive Presence',
      description: 'Achieve a score of 85 or above in any scenario.',
      iconEmoji: '👑',
      badgeColor: Color(0xFF00B894),
      xpReward: 150,
      currentProgress: 1,
      targetProgress: 1,
      isUnlocked: true,
    ),
    const SimuAchievement(
      id: 'ach_polymath',
      category: AchievementCategory.special,
      title: 'Cross-Discipline Explorer',
      description: 'Practice at least one scenario in 3 different categories.',
      iconEmoji: '🌍',
      badgeColor: Color(0xFF0984E3),
      xpReward: 200,
      currentProgress: 2,
      targetProgress: 3,
      isUnlocked: false,
    ),
    const SimuAchievement(
      id: 'ach_perfectionist',
      category: AchievementCategory.mastery,
      title: 'Century Club',
      description: 'Score a perfect 95+ in any behavioral or technical challenge.',
      iconEmoji: '💎',
      badgeColor: Color(0xFFA29BFE),
      xpReward: 250,
      currentProgress: 0,
      targetProgress: 1,
      isUnlocked: false,
    ),
  ];

  void claimReward({
    required String scenarioId,
    required int amount,
    required String reason,
    int score = 88,
    String scenarioTitle = 'Tell Me About Yourself',
    ChallengeCategory category = ChallengeCategory.interviews,
  }) {
    final reward = XPReward(
      amount: amount,
      sourceId: scenarioId,
      reason: reason,
      timestamp: DateTime.now(),
    );

    final historyItem = PracticeHistoryItem(
      id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
      scenarioId: scenarioId,
      scenarioTitle: scenarioTitle,
      category: category,
      score: score,
      xpEarned: amount,
      completedAt: DateTime.now(),
      status: PracticeHistoryStatus.completed,
      headline: reason,
    );

    final updatedScenarios = Set<String>.from(state.completedScenarios)
      ..add(scenarioId);
    final updatedRewards = [...state.rewardHistory, reward];
    final updatedHistory = [historyItem, ...state.history];

    state = state.copyWith(
      completedScenarios: updatedScenarios,
      rewardHistory: updatedRewards,
      history: updatedHistory,
    );
  }
}
