/// Speaker in a simulation turn.
enum TurnSpeaker {
  interviewer,
  user,
  system,
}

/// Mode of input used by user.
enum TurnInputMode {
  voice,
  text,
}

/// Represents one exchange in an interactive simulation.
class SimulationTurn {
  const SimulationTurn({
    required this.turnNumber,
    required this.speaker,
    required this.text,
    required this.timestamp,
    this.inputMode = TurnInputMode.text,
    this.detectedTone,
  });

  final int turnNumber;
  final TurnSpeaker speaker;
  final String text;
  final DateTime timestamp;
  final TurnInputMode inputMode;
  final String? detectedTone;
}
