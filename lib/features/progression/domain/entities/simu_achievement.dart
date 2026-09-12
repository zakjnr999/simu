import 'package:flutter/material.dart';

/// Categories for gamified Simu achievements.
enum AchievementCategory {
  milestones('Milestones'),
  streaks('Streaks'),
  mastery('Mastery'),
  special('Special');

  const AchievementCategory(this.label);
  final String label;
}

/// Domain model for an unlockable achievement.
class SimuAchievement {
  const SimuAchievement({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.badgeColor,
    required this.xpReward,
    required this.currentProgress,
    required this.targetProgress,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  final String id;
  final AchievementCategory category;
  final String title;
  final String description;
  final String iconEmoji;
  final Color badgeColor;
  final int xpReward;
  final int currentProgress;
  final int targetProgress;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  double get progressRatio =>
      targetProgress > 0 ? (currentProgress / targetProgress).clamp(0.0, 1.0) : 1.0;
}
