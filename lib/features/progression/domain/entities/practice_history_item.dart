import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';

/// Status of a past practice session.
enum PracticeHistoryStatus {
  completed('Completed'),
  attempted('Attempted'),
  replayable('Replayable'),
  incomplete('Incomplete');

  const PracticeHistoryStatus(this.label);
  final String label;
}

/// Domain model for a recorded practice session in the user's history.
class PracticeHistoryItem {
  const PracticeHistoryItem({
    required this.id,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.category,
    required this.score,
    required this.xpEarned,
    required this.completedAt,
    required this.status,
    required this.headline,
    this.strengthsCount = 3,
    this.growthCount = 2,
  });

  final String id;
  final String scenarioId;
  final String scenarioTitle;
  final ChallengeCategory category;
  final int score;
  final int xpEarned;
  final DateTime completedAt;
  final PracticeHistoryStatus status;
  final String headline;
  final int strengthsCount;
  final int growthCount;
}
