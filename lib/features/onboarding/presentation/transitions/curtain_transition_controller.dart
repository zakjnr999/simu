import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_state.dart';

final curtainTransitionControllerProvider =
    NotifierProvider<CurtainTransitionController, CurtainTransitionState>(
  CurtainTransitionController.new,
);

typedef CurtainTransitionRunner = Future<bool> Function({
  required Future<bool> Function() prepare,
  required Future<void> Function() navigate,
  required bool reduceMotion,
});

/// Coordinates the onboarding → Meet Ace theatrical curtain transition.
///
/// Animation frames are driven by [OnboardingCurtainTransitionOverlay] so the
/// [AnimationController] always has a mounted [TickerProvider].
class CurtainTransitionController extends Notifier<CurtainTransitionState> {
  CurtainTransitionRunner? _runner;
  Completer<void>? _activeCompleter;

  @override
  CurtainTransitionState build() => const CurtainTransitionState();

  bool get hasRunner => _runner != null;

  void registerRunner(CurtainTransitionRunner runner) {
    _runner = runner;
    if (kDebugMode) {
      debugPrint('[Curtain] runner registered');
    }
  }

  void unregisterRunner() {
    _runner = null;
    if (kDebugMode) {
      debugPrint('[Curtain] runner unregistered');
    }
  }

  void updateFromOverlay({
    CurtainTransitionPhase? phase,
    double? progress,
    bool? isVisible,
    bool? blocksTouches,
  }) {
    state = state.copyWith(
      phase: phase,
      progress: progress,
      isVisible: isVisible,
      blocksTouches: blocksTouches,
    );
  }

  void reset() {
    state = const CurtainTransitionState();
  }

  /// Runs close → hold → navigate → open. Returns false if already active or failed.
  Future<bool> start({
    required Future<bool> Function() prepare,
    required Future<void> Function() navigate,
    bool reduceMotion = false,
  }) async {
    if (state.isActive) {
      if (kDebugMode) {
        debugPrint('[Curtain] start blocked: already active (${state.phase})');
      }
      return false;
    }

    final runner = _runner;
    if (runner == null) {
      if (kDebugMode) {
        debugPrint('[Curtain] start blocked: overlay runner not registered');
      }
      return false;
    }

    _activeCompleter = Completer<void>();
    final localCompleter = _activeCompleter!;

    try {
      final success = await runner(
        prepare: prepare,
        navigate: navigate,
        reduceMotion: reduceMotion,
      );

      if (localCompleter.isCompleted) {
        return false;
      }

      return success;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[Curtain] transition failed: $error\n$stackTrace');
      }
      reset();
      return false;
    } finally {
      _activeCompleter = null;
    }
  }

  Future<void> cancel() async {
    if (!(_activeCompleter?.isCompleted ?? true)) {
      _activeCompleter?.complete();
    }
    reset();
  }
}
