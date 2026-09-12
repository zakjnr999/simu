import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/presentation/pages/live_simulation_page.dart';

void main() {
  testWidgets('LiveSimulationPage renders dialogue, stage, Ace coach bar, and input panel',
      (tester) async {
    const scenarioId = 'interview-tell-me-about-yourself';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          simulationRepositoryProvider
              .overrideWithValue(MockSimulationRepository()),
        ],
        child: const MaterialApp(
          home: LiveSimulationPage(scenarioId: scenarioId),
        ),
      ),
    );

    // Pump and resolve async init
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify stage, partner, Ace coaching, and input elements
    expect(find.text('Tell Me About Yourself'), findsOneWidget);
    expect(find.text('Turn 1 of 3'), findsOneWidget);
    expect(find.text('Sarah Chen'), findsWidgets);
    expect(find.text("Ace's Tip"), findsNothing); // It's open by default
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Present-Past-Future structure'), findsOneWidget);
  });
}
