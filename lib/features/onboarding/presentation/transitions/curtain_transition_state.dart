/// Lifecycle states for the onboarding → Meet Ace curtain transition.
enum CurtainTransitionPhase {
  idle,
  closing,
  closed,
  opening,
  complete,
}

/// Observable state for the global curtain transition overlay.
class CurtainTransitionState {
  const CurtainTransitionState({
    this.phase = CurtainTransitionPhase.idle,
    this.progress = 0,
    this.isVisible = false,
    this.blocksTouches = false,
  });

  final CurtainTransitionPhase phase;
  final double progress;
  final bool isVisible;
  final bool blocksTouches;

  bool get isActive =>
      phase != CurtainTransitionPhase.idle &&
      phase != CurtainTransitionPhase.complete;

  CurtainTransitionState copyWith({
    CurtainTransitionPhase? phase,
    double? progress,
    bool? isVisible,
    bool? blocksTouches,
  }) {
    return CurtainTransitionState(
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      isVisible: isVisible ?? this.isVisible,
      blocksTouches: blocksTouches ?? this.blocksTouches,
    );
  }
}
