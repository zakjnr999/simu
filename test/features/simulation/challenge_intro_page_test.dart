import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/presentation/pages/challenge_intro_page.dart';

void main() {
  testWidgets('ChallengeIntroPage renders mission brief, partner, Ace tip, and CTA',
      (tester) async {
    const scenarioId = 'interview-tell-me-about-yourself';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          simulationRepositoryProvider
              .overrideWithValue(MockSimulationRepository()),
        ],
        child: const MaterialApp(
          home: ChallengeIntroPage(scenarioId: scenarioId),
        ),
      ),
    );

    // Initial pump + resolve async FutureBuilder
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify key titles and UI components
    expect(find.text('Mission Brief'), findsOneWidget);
    expect(find.text('Tell Me About Yourself'), findsOneWidget);
    expect(find.text('YOUR MISSION OBJECTIVE'), findsOneWidget);
    expect(find.text('Sarah Chen • VP of Product'), findsOneWidget);
    expect(find.text('Start Simulation'), findsOneWidget);
  });
}
