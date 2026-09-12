import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/pages/meet_ace_page.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';

void main() {
  testWidgets('MeetAcePage renders headline, features panel, and CTA',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MeetAcePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.textContaining("Here's what we'll do together"), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Improve'), findsOneWidget);
    expect(find.text('Level Up'), findsOneWidget);
    expect(find.byType(OnboardingTactileSurface), findsOneWidget);
    expect(find.byType(OnboardingPrimaryCta), findsOneWidget);
    expect(find.text("Let's go!"), findsOneWidget);
  });

  test('OnboardingState.totalOnboardingXp sums all selected bonuses', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(onboardingControllerProvider);
    final expected = (state.selectedGoal?.xpBonus ?? 0) +
        (state.selectedMasteryGoal?.xpBonus ?? 0) +
        (state.selectedExperienceLevel?.xpBonus ?? 0) +
        (state.selectedPersonalGoal?.xpBonus ?? 0) +
        (state.selectedCommitment?.xpBonus ?? 0);

    expect(state.totalOnboardingXp, expected);
    expect(state.totalOnboardingXp, greaterThan(0));
  });
}
