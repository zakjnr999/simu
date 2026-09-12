import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';
import 'package:simu/features/simulation/domain/entities/simulation_evaluation.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';

/// Interaction status during a live simulation.
enum SimulationStatus {
  ready,
  listening,
  transcribing,
  thinking,
  speaking,
  completed,
  error,
}

/// Presentation state for the live simulation session.
class SimulationState {
  const SimulationState({
    required this.scenario,
    this.status = SimulationStatus.ready,
    this.turns = const [],
    this.isVoiceMode = false,
    this.isMicActive = false,
    this.currentInputText = '',
    this.evaluation,
    this.coachHintVisible = true,
    this.turnIndex = 1,
    this.errorMessage,
  });

  final ChallengeScenario scenario;
  final SimulationStatus status;
  final List<SimulationTurn> turns;
  final bool isVoiceMode;
  final bool isMicActive;
  final String currentInputText;
  final SimulationEvaluation? evaluation;
  final bool coachHintVisible;
  final int turnIndex;
  final String? errorMessage;

  bool get isCompleted => status == SimulationStatus.completed;
  bool get isProcessing =>
      status == SimulationStatus.thinking ||
      status == SimulationStatus.transcribing;

  SimulationState copyWith({
    ChallengeScenario? scenario,
    SimulationStatus? status,
    List<SimulationTurn>? turns,
    bool? isVoiceMode,
    bool? isMicActive,
    String? currentInputText,
    SimulationEvaluation? evaluation,
    bool? coachHintVisible,
    int? turnIndex,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SimulationState(
      scenario: scenario ?? this.scenario,
      status: status ?? this.status,
      turns: turns ?? this.turns,
      isVoiceMode: isVoiceMode ?? this.isVoiceMode,
      isMicActive: isMicActive ?? this.isMicActive,
      currentInputText: currentInputText ?? this.currentInputText,
      evaluation: evaluation ?? this.evaluation,
      coachHintVisible: coachHintVisible ?? this.coachHintVisible,
      turnIndex: turnIndex ?? this.turnIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
