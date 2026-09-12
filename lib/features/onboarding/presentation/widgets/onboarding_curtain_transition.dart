import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_controller.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_state.dart';

/// Full-screen theatrical curtain overlay for onboarding → Meet Ace.
class OnboardingCurtainTransitionOverlay extends ConsumerStatefulWidget {
  const OnboardingCurtainTransitionOverlay({super.key});

  static const String leftCurtainAsset =
      'assets/illustrations/onboarding/curtains/curtain_left.png';
  static const String rightCurtainAsset =
      'assets/illustrations/onboarding/curtains/curtain_right.png';

  /// Both curtain PNGs are 941×1672 — fabric width scales from screen height.
  static const double curtainAspect = 941 / 1672;

  /// Measured from asset alpha: purple fabric ends at ~59% of left image width.
  static const double leftFabricEndRatio = 0.589;

  /// Measured from asset alpha: purple fabric starts at ~45% of right image width.
  static const double rightFabricStartRatio = 0.452;

  /// Extra overlap so transparent PNG padding does not leave a center gap.
  static const double seamOverlapPx = 16;

  /// Computes open/closed translate offsets so fabric inner edges meet at center.
  @visibleForTesting
  static ({double left, double right}) offsetsFor({
    required double screenWidth,
    required double panelWidth,
    required double progress,
  }) {
    final closedLeft = (screenWidth / 2) -
        (panelWidth * leftFabricEndRatio) +
        seamOverlapPx;
    final closedRight = (screenWidth / 2) -
        screenWidth +
        (panelWidth * (1 - rightFabricStartRatio)) -
        seamOverlapPx;
    final openLeft = -panelWidth;
    final openRight = panelWidth;

    return (
      left: lerpDouble(openLeft, closedLeft, progress) ?? openLeft,
      right: lerpDouble(openRight, closedRight, progress) ?? openRight,
    );
  }

  @override
  ConsumerState<OnboardingCurtainTransitionOverlay> createState() =>
      _OnboardingCurtainTransitionOverlayState();
}

class _OnboardingCurtainTransitionOverlayState
    extends ConsumerState<OnboardingCurtainTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  CurtainTransitionController? _notifier;

  bool _isVisible = false;
  bool _blocksTouches = false;
  double _renderProgress = 0;
  int _paintLogCounter = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    _animationController.addListener(_handleTick);

    _notifier = ref.read(curtainTransitionControllerProvider.notifier);
    _notifier!.registerRunner(_runTransition);
  }

  @override
  void dispose() {
    _animationController.removeListener(_handleTick);
    _animationController.dispose();
    _notifier?.unregisterRunner();
    _notifier = null;
    super.dispose();
  }

  void _handleTick() {
    if (!mounted) {
      return;
    }

    setState(() => _renderProgress = _animationController.value);
    _notifier?.updateFromOverlay(progress: _renderProgress);
  }

  void _setOverlayState({
    bool? isVisible,
    bool? blocksTouches,
    double? progress,
  }) {
    setState(() {
      if (isVisible != null) {
        _isVisible = isVisible;
      }
      if (blocksTouches != null) {
        _blocksTouches = blocksTouches;
      }
      if (progress != null) {
        _renderProgress = progress;
      }
    });

    if (kDebugMode && isVisible == true) {
      debugPrint('[Curtain] overlay shown (progress=$_renderProgress)');
    }
    if (kDebugMode && isVisible == false) {
      debugPrint('[Curtain] overlay hidden');
    }
  }

  Future<void> _waitForNextFrame() async {
    final completer = Completer<void>();
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    await completer.future;
  }

  Future<void> _animateTo({
    required double target,
    required Duration duration,
    required Curve curve,
  }) async {
    final startedAt = DateTime.now();
    _animationController.duration = duration;
    await _animationController.animateTo(target, curve: curve);

    if (kDebugMode) {
      final elapsed = DateTime.now().difference(startedAt).inMilliseconds;
      debugPrint(
        '[Curtain] animated to $target in ${elapsed}ms '
        '(requested ${duration.inMilliseconds}ms)',
      );
    }
  }

  Future<bool> _runTransition({
    required Future<bool> Function() prepare,
    required Future<void> Function() navigate,
    required bool reduceMotion,
  }) async {
    final notifier = _notifier;
    if (notifier == null) {
      return false;
    }

    final closeDuration = reduceMotion
        ? AppMotion.curtainCloseReduced
        : AppMotion.curtainClose;
    final holdDuration = reduceMotion
        ? AppMotion.curtainHoldReduced
        : AppMotion.curtainHold;
    final openDuration = reduceMotion
        ? AppMotion.curtainOpenReduced
        : AppMotion.curtainOpen;

    if (kDebugMode) {
      debugPrint(
        '[Curtain] transition start '
        '(reduceMotion=$reduceMotion, '
        'disableAnimations=${MediaQuery.disableAnimationsOf(context)})',
      );
    }

    _animationController.stop();
    _animationController.value = 0;

    notifier.updateFromOverlay(
      phase: CurtainTransitionPhase.closing,
      progress: 0,
      isVisible: true,
      blocksTouches: true,
    );
    _setOverlayState(isVisible: true, blocksTouches: true, progress: 0);

    await _waitForNextFrame();
    await _waitForNextFrame();

    await _animateTo(
      target: 1,
      duration: closeDuration,
      curve: AppMotion.curtainCurve,
    );

    if (kDebugMode) {
      debugPrint('[Curtain] closed at progress=${_animationController.value}');
    }

    notifier.updateFromOverlay(phase: CurtainTransitionPhase.closed);

    final prepared = await prepare();
    if (!prepared) {
      notifier.updateFromOverlay(phase: CurtainTransitionPhase.opening);
      await _animateTo(
        target: 0,
        duration: openDuration,
        curve: AppMotion.curtainCurve,
      );
      notifier.reset();
      _setOverlayState(isVisible: false, blocksTouches: false, progress: 0);
      return false;
    }

    await navigate();

    if (kDebugMode) {
      debugPrint('[Curtain] navigated, holding ${holdDuration.inMilliseconds}ms');
    }

    await Future<void>.delayed(holdDuration);

    notifier.updateFromOverlay(phase: CurtainTransitionPhase.opening);
    await _animateTo(
      target: 0,
      duration: openDuration,
      curve: AppMotion.curtainCurve,
    );

    if (kDebugMode) {
      debugPrint('[Curtain] transition complete');
    }

    notifier.updateFromOverlay(
      phase: CurtainTransitionPhase.complete,
      progress: 0,
      blocksTouches: false,
      isVisible: false,
    );
    notifier.reset();
    _setOverlayState(isVisible: false, blocksTouches: false, progress: 0);

    return true;
  }

  void _logPaintSize() {
    if (!kDebugMode || !_isVisible) {
      return;
    }

    _paintLogCounter++;
    if (_paintLogCounter % 12 != 0 && _renderProgress != 0 && _renderProgress != 1) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final box = context.findRenderObject() as RenderBox?;
      debugPrint(
        '[Curtain] painted progress=${_renderProgress.toStringAsFixed(2)} '
        'size=${box?.size}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(curtainTransitionControllerProvider);

    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    _logPaintSize();

    return IgnorePointer(
      ignoring: !_blocksTouches,
      child: _CurtainTransitionLayer(
        progress: _renderProgress,
      ),
    );
  }
}

class _CurtainTransitionLayer extends StatelessWidget {
  const _CurtainTransitionLayer({
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final panelWidth =
            screenHeight * OnboardingCurtainTransitionOverlay.curtainAspect;

        final offsets = OnboardingCurtainTransitionOverlay.offsetsFor(
          screenWidth: screenWidth,
          panelWidth: panelWidth,
          progress: progress,
        );

        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Transform.translate(
                offset: Offset(offsets.left, 0),
                child: _CurtainPanel(
                  assetPath: OnboardingCurtainTransitionOverlay.leftCurtainAsset,
                  height: screenHeight,
                  width: panelWidth,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(offsets.right, 0),
                child: _CurtainPanel(
                  assetPath: OnboardingCurtainTransitionOverlay.rightCurtainAsset,
                  height: screenHeight,
                  width: panelWidth,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CurtainPanel extends StatelessWidget {
  const _CurtainPanel({
    required this.assetPath,
    required this.height,
    required this.width,
    required this.alignment,
  });

  final String assetPath;
  final double height;
  final double width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        alignment: alignment,
        fit: BoxFit.fitHeight,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            debugPrint('[Curtain] failed to load $assetPath: $error');
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
