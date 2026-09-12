import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';
import 'package:simu/features/simulation/domain/entities/simulation_evaluation.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';

/// Repository interface for fetching scenarios and running simulation logic.
abstract class SimulationRepository {
  /// Fetch a scenario by ID.
  Future<ChallengeScenario?> getScenario(String id);

  /// Fetch all available scenarios for a category.
  Future<List<ChallengeScenario>> getScenariosByCategory(ChallengeCategory category);

  /// Generate or fetch the next interviewer reply in the conversation.
  Future<String> getNextInterviewerResponse({
    required ChallengeScenario scenario,
    required List<SimulationTurn> previousTurns,
    required String userReply,
  });

  /// Submit turns and receive a structured evaluation report.
  Future<SimulationEvaluation> evaluateSession({
    required ChallengeScenario scenario,
    required List<SimulationTurn> turns,
  });
}
