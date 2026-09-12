import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';

/// Represents a rapid micro-drill focused on isolating a specific conversational reflex.
class DrillItem {
  const DrillItem({
    required this.id,
    required this.title,
    required this.targetWeakness,
    required this.framework,
    required this.durationSeconds,
    required this.difficulty,
    required this.xpReward,
    required this.iconEmoji,
    required this.scenarioId,
    required this.description,
  });

  final String id;
  final String title;
  final String targetWeakness;
  final String framework;
  final int durationSeconds;
  final ChallengeDifficulty difficulty;
  final int xpReward;
  final String iconEmoji;
  final String scenarioId;
  final String description;

  String get durationLabel => '$durationSeconds SEC';
}
