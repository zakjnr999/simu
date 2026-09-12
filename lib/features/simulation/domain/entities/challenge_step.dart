/// Discrete turn or step within a challenge scenario.
class ChallengeStep {
  const ChallengeStep({
    required this.stepNumber,
    required this.prompt,
    required this.coachHint,
    this.suggestedOptions = const [],
  });

  final int stepNumber;
  final String prompt;
  final String coachHint;
  final List<String> suggestedOptions;
}
