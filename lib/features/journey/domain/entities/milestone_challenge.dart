/// Represents an individual challenge within a journey milestone.
class MilestoneChallenge {
  const MilestoneChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.xpReward,
    required this.difficulty,
    this.isCompleted = false,
    this.isLocked = false,
    this.scenarioId,
  });

  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final int xpReward;
  final String difficulty;
  final bool isCompleted;
  final bool isLocked;
  final String? scenarioId;

  MilestoneChallenge copyWith({
    bool? isCompleted,
    bool? isLocked,
  }) {
    return MilestoneChallenge(
      id: id,
      title: title,
      description: description,
      durationMinutes: durationMinutes,
      xpReward: xpReward,
      difficulty: difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      scenarioId: scenarioId,
    );
  }
}
