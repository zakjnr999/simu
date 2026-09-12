import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';
import 'package:simu/features/simulation/domain/repositories/simulation_repository.dart';
import 'package:simu/features/simulation/presentation/state/simulation_state.dart';

final simulationControllerProvider =
    StateNotifierProvider.family<SimulationController, SimulationState, String>(
  (ref, scenarioId) {
    final repository = ref.watch(simulationRepositoryProvider);
    return SimulationController(scenarioId, repository);
  },
);

class SimulationController extends StateNotifier<SimulationState> {
  SimulationController(this.scenarioId, this._repository)
      : super(
          SimulationState(
            scenario: ChallengeScenario(
              id: scenarioId,
              category: ChallengeCategory.interviews,
              title: 'Loading Challenge...',
              situationSetup: '',
              userObjective: '',
              interviewerName: '',
              interviewerRole: '',
              interviewerCompany: '',
              skillsPracticed: const [],
              difficulty: ChallengeDifficulty.beginner,
              durationMinutes: 8,
              xpReward: 180,
              aceGuidance: '',
              openingPrompt: '',
              maxTurns: 3,
            ),
          ),
        ) {
    _initScenario();
  }

  final String scenarioId;
  final SimulationRepository _repository;

  Future<void> _initScenario() async {
    final scenario = await _repository.getScenario(scenarioId);
    if (scenario == null) {
      state = state.copyWith(errorMessage: 'Scenario not found');
      return;
    }

    // Seed the first opening turn from the interviewer
    final initialTurn = SimulationTurn(
      turnNumber: 1,
      speaker: TurnSpeaker.interviewer,
      text: scenario.openingPrompt,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      scenario: scenario,
      turns: [initialTurn],
      status: SimulationStatus.ready,
      turnIndex: 1,
    );
  }

  void updateInputText(String text) {
    state = state.copyWith(currentInputText: text);
  }

  void toggleVoiceMode() {
    final nextVoiceMode = !state.isVoiceMode;
    state = state.copyWith(
      isVoiceMode: nextVoiceMode,
      isMicActive: false,
    );
  }

  void toggleMic() {
    if (!state.isVoiceMode) {
      state = state.copyWith(isVoiceMode: true, isMicActive: true);
      return;
    }
    final nextMic = !state.isMicActive;
    state = state.copyWith(
      isMicActive: nextMic,
      status: nextMic ? SimulationStatus.listening : SimulationStatus.ready,
    );
  }

  void toggleCoachHint() {
    state = state.copyWith(coachHintVisible: !state.coachHintVisible);
  }

  Future<void> submitUserResponse(String message, {bool isVoice = false}) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty || state.isProcessing) return;

    final currentUserTurnCount =
        state.turns.where((t) => t.speaker == TurnSpeaker.user).length + 1;

    final userTurn = SimulationTurn(
      turnNumber: currentUserTurnCount,
      speaker: TurnSpeaker.user,
      text: trimmed,
      timestamp: DateTime.now(),
      inputMode: isVoice ? TurnInputMode.voice : TurnInputMode.text,
    );

    final updatedTurns = [...state.turns, userTurn];

    state = state.copyWith(
      turns: updatedTurns,
      currentInputText: '',
      isMicActive: false,
      status: SimulationStatus.thinking,
    );

    // Check if we reached the maximum turns
    if (currentUserTurnCount >= state.scenario.maxTurns) {
      // Evaluate session
      final evaluation = await _repository.evaluateSession(
        scenario: state.scenario,
        turns: updatedTurns,
      );

      state = state.copyWith(
        evaluation: evaluation,
        status: SimulationStatus.completed,
      );
      return;
    }

    // Otherwise get the next interviewer response
    final responseText = await _repository.getNextInterviewerResponse(
      scenario: state.scenario,
      previousTurns: updatedTurns,
      userReply: trimmed,
    );

    final interviewerTurn = SimulationTurn(
      turnNumber: currentUserTurnCount + 1,
      speaker: TurnSpeaker.interviewer,
      text: responseText,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      turns: [...updatedTurns, interviewerTurn],
      status: SimulationStatus.ready,
      turnIndex: currentUserTurnCount + 1,
    );
  }

  void resetSimulation() {
    _initScenario();
  }
}
