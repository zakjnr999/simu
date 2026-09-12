/// Dimension evaluated during a simulation.
class EvaluationDimension {
  const EvaluationDimension({
    required this.name,
    required this.score,
    required this.feedback,
  });

  final String name;
  final int score;
  final String feedback;
}

/// Structured assessment of a simulation session.
class SimulationEvaluation {
  const SimulationEvaluation({
    required this.evaluationId,
    required this.scenarioId,
    required this.overallScore,
    required this.headline,
    required this.summary,
    required this.dimensions,
    required this.strengths,
    required this.weaknesses,
    required this.improvedExamples,
    required this.recommendedDrillTitle,
    required this.recommendedDrillDescription,
    required this.xpEarned,
  });

  final String evaluationId;
  final String scenarioId;
  final int overallScore;
  final String headline;
  final String summary;
  final List<EvaluationDimension> dimensions;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> improvedExamples;
  final String recommendedDrillTitle;
  final String recommendedDrillDescription;
  final int xpEarned;
}
