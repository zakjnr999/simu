import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_controller.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_state.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_curtain_transition.dart';

Future<void> _pumpUntilIdle(
  WidgetTester tester,
  Future<bool> transitionFuture,
) async {
  var completed = false;
  unawaited(transitionFuture.then((_) => completed = true));

  for (var i = 0; i < 80 && !completed; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }

  await transitionFuture;
}

Widget _overlayHarness({required Widget child}) {
  return ProviderScope(
    child: MaterialApp(
      home: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          child,
          const OnboardingCurtainTransitionOverlay(),
        ],
      ),
    ),
  );
}

void main() {
  testWidgets('curtain overlay is hidden while idle', (tester) async {
    await tester.pumpWidget(
      _overlayHarness(child: const Scaffold(body: SizedBox())),
    );

    await tester.pump();

    expect(find.byType(Image), findsNothing);
  });

  testWidgets('curtain transition shows panels while closing', (tester) async {
    final prepareGate = Completer<bool>();

    await tester.pumpWidget(
      _overlayHarness(child: const Scaffold(body: SizedBox())),
    );
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(OnboardingCurtainTransitionOverlay)),
    );
    final notifier =
        container.read(curtainTransitionControllerProvider.notifier);

    expect(notifier.hasRunner, isTrue);

    final transitionFuture = notifier.start(
      prepare: () => prepareGate.future,
      navigate: () async {},
      reduceMotion: true,
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(
      container.read(curtainTransitionControllerProvider).phase,
      CurtainTransitionPhase.closing,
    );
    expect(find.byType(Image), findsWidgets);

    prepareGate.complete(true);
    await _pumpUntilIdle(tester, transitionFuture);

    expect(
      container.read(curtainTransitionControllerProvider).phase,
      CurtainTransitionPhase.idle,
    );
  });

  testWidgets('curtain transition runs close, navigate, and open sequence',
      (tester) async {
    var prepared = false;
    var navigated = false;

    await tester.pumpWidget(
      _overlayHarness(child: const Scaffold(body: SizedBox())),
    );
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(OnboardingCurtainTransitionOverlay)),
    );
    final notifier =
        container.read(curtainTransitionControllerProvider.notifier);

    final transitionFuture = notifier.start(
      prepare: () async {
        prepared = true;
        return true;
      },
      navigate: () async {
        navigated = true;
      },
      reduceMotion: true,
    );

    await tester.pump();
    expect(
      container.read(curtainTransitionControllerProvider).phase,
      CurtainTransitionPhase.closing,
    );

    await _pumpUntilIdle(tester, transitionFuture);

    expect(prepared, isTrue);
    expect(navigated, isTrue);
    expect(
      container.read(curtainTransitionControllerProvider).phase,
      CurtainTransitionPhase.idle,
    );
  });

  testWidgets('duplicate curtain transitions are ignored while active',
      (tester) async {
    await tester.pumpWidget(
      _overlayHarness(child: const Scaffold(body: SizedBox())),
    );
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(OnboardingCurtainTransitionOverlay)),
    );
    final notifier =
        container.read(curtainTransitionControllerProvider.notifier);
    final prepareGate = Completer<bool>();

    final firstTransition = notifier.start(
      prepare: () => prepareGate.future,
      navigate: () async {},
      reduceMotion: true,
    );

    await tester.pump();

    final secondStart = await notifier.start(
      prepare: () async => true,
      navigate: () async {},
      reduceMotion: true,
    );

    expect(secondStart, isFalse);

    prepareGate.complete(true);
    await _pumpUntilIdle(tester, firstTransition);
  });

  test('fabric seams meet at screen center when closed', () {
    const screenWidth = 393.0;
    const panelWidth = 480.0;

    final closed = OnboardingCurtainTransitionOverlay.offsetsFor(
      screenWidth: screenWidth,
      panelWidth: panelWidth,
      progress: 1,
    );

    final leftSeam =
        closed.left + panelWidth * OnboardingCurtainTransitionOverlay.leftFabricEndRatio;
    final rightSeam = screenWidth -
        panelWidth +
        closed.right +
        panelWidth * OnboardingCurtainTransitionOverlay.rightFabricStartRatio;

    expect(leftSeam, closeTo(screenWidth / 2 + OnboardingCurtainTransitionOverlay.seamOverlapPx, 0.01));
    expect(rightSeam, closeTo(screenWidth / 2 - OnboardingCurtainTransitionOverlay.seamOverlapPx, 0.01));
    expect(leftSeam, greaterThan(rightSeam));
  });

  test('curtain offsets keep panels off-screen when open', () {
    const screenWidth = 393.0;
    const panelWidth = 480.0;

    final open = OnboardingCurtainTransitionOverlay.offsetsFor(
      screenWidth: screenWidth,
      panelWidth: panelWidth,
      progress: 0,
    );

    expect(open.left, -panelWidth);
    expect(open.right, panelWidth);
  });
}
