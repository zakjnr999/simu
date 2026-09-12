import 'package:simu/features/journey/domain/entities/milestone_challenge.dart';

/// Difficulty tier for a journey milestone preview.
enum JourneyMilestoneDifficulty {
  easy,
  medium,
  hard,
}

extension JourneyMilestoneDifficultyX on JourneyMilestoneDifficulty {
  String get label => switch (this) {
        JourneyMilestoneDifficulty.easy => 'Easy',
        JourneyMilestoneDifficulty.medium => 'Medium',
        JourneyMilestoneDifficulty.hard => 'Hard',
      };
}

/// A major milestone on the user's learning journey (not a single challenge).
class JourneyMilestone {
  const JourneyMilestone({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.xpReward,
    required this.iconAssetPath,
    this.description = '',
    this.challenges = const [],
    this.isLocked = false,
    this.isActive = false,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final JourneyMilestoneDifficulty difficulty;
  final int xpReward;
  final String iconAssetPath;
  final String description;
  final List<MilestoneChallenge> challenges;
  final bool isLocked;
  final bool isActive;
  final bool isCompleted;

  String get rewardLabel => '${difficulty.label} · +$xpReward XP';

  int get completedChallengeCount =>
      challenges.where((c) => c.isCompleted).length;

  double get progressRatio => challenges.isEmpty
      ? (isCompleted ? 1.0 : 0.0)
      : (completedChallengeCount / challenges.length).clamp(0.0, 1.0);

  JourneyMilestone copyWith({
    bool? isLocked,
    bool? isActive,
    bool? isCompleted,
    String? iconAssetPath,
    String? description,
    List<MilestoneChallenge>? challenges,
  }) {
    return JourneyMilestone(
      id: id,
      title: title,
      difficulty: difficulty,
      xpReward: xpReward,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
      description: description ?? this.description,
      challenges: challenges ?? this.challenges,
      isLocked: isLocked ?? this.isLocked,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
