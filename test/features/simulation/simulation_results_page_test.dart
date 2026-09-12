import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/presentation/pages/simulation_results_page.dart';

void main() {
  testWidgets('SimulationResultsPage renders celebration, XP, skill breakdown, and drill',
      (tester) async {
    const scenarioId = 'interview-tell-me-about-yourself';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          simulationRepositoryProvider
              .overrideWithValue(MockSimulationRepository()),
        ],
        child: const MaterialApp(
          home: SimulationResultsPage(scenarioId: scenarioId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Performance Review'), findsOneWidget);
    expect(find.text('Impressive Poise & Structure!'), findsOneWidget);
    expect(find.text('+180 XP'), findsOneWidget);
    expect(find.text('88 / 100'), findsOneWidget);
    expect(find.text('SKILL BREAKDOWN'), findsOneWidget);
    expect(find.text('Clarity & Structure'), findsOneWidget);
    expect(find.text('KEY STRENGTHS'), findsOneWidget);
    expect(find.text('AREAS FOR GROWTH'), findsOneWidget);
    expect(find.text('RECOMMENDED DRILL'), findsOneWidget);
    expect(find.text('30-Second Concise Impact Drill'), findsOneWidget);
    expect(find.text('Claim +180 XP & Continue'), findsOneWidget);
    expect(find.text('Practice Again'), findsOneWidget);
  });
}
