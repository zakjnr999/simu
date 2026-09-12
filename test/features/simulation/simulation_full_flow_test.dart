import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/features/home/presentation/pages/home_page.dart';
import 'package:simu/features/home/presentation/widgets/home_todays_challenge_card.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/presentation/pages/challenge_intro_page.dart';
import 'package:simu/features/simulation/presentation/pages/live_simulation_page.dart';
import 'package:simu/features/simulation/presentation/pages/simulation_results_page.dart';

void main() {
  testWidgets('Complete Simulation Loop: Home -> Intro -> Simulation -> Results -> Home with XP',
      (tester) async {
    const scenarioId = 'interview-tell-me-about-yourself';

    final router = GoRouter(
      initialLocation: RouteNames.home,
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => const Scaffold(body: HomePage()),
        ),
        GoRoute(
          path: RouteNames.simulationIntro,
          builder: (context, state) => ChallengeIntroPage(
            scenarioId: state.pathParameters['id'] ?? scenarioId,
          ),
        ),
        GoRoute(
          path: RouteNames.simulation,
          builder: (context, state) => LiveSimulationPage(
            scenarioId: state.pathParameters['id'] ?? scenarioId,
          ),
        ),
        GoRoute(
          path: RouteNames.simulationResults,
          builder: (context, state) => SimulationResultsPage(
            scenarioId: state.pathParameters['id'] ?? scenarioId,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          simulationRepositoryProvider
              .overrideWithValue(MockSimulationRepository()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Home Page verifies challenge card
    expect(find.byType(HomeTodaysChallengeCard), findsOneWidget);
    final startButton = find.text('Start Challenge');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // 2. Challenge Intro Page
    expect(find.text('Mission Brief'), findsOneWidget);
    expect(find.text('Tell Me About Yourself'), findsOneWidget);
    final startSimButton = find.widgetWithText(SimuPrimaryAction, 'Start Simulation');
    expect(startSimButton, findsOneWidget);
    await tester.tap(startSimButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // 3. Live Simulation Page
    expect(find.text('Turn 1 of 3'), findsOneWidget);
    expect(find.text('Sarah Chen'), findsWidgets);

    // Tap quick suggestion to submit Turn 1
    final suggestion1 = find.text('Present-Past-Future structure');
    expect(suggestion1, findsOneWidget);
    await tester.tap(suggestion1);
    await tester.pump(const Duration(milliseconds: 100));

    // Tap send button
    final sendButton = find.byTooltip('Send response');
    expect(sendButton, findsOneWidget);
    await tester.tap(sendButton);
    // Allow turn progression & mock delay
    await tester.pump(const Duration(milliseconds: 600));

    // Turn 2
    expect(find.text('Turn 2 of 3'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'My second turn response.');
    await tester.tap(sendButton);
    await tester.pump(const Duration(milliseconds: 600));

    // Turn 3
    expect(find.text('Turn 3 of 3'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'My final turn response.');
    await tester.tap(sendButton);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 300));

    // 4. Results Page
    expect(find.text('Performance Review'), findsOneWidget);
    expect(find.text('Impressive Poise & Structure!'), findsOneWidget);
    expect(find.text('Claim +180 XP & Continue'), findsOneWidget);

    // Tap Claim XP
    final claimButton = find.widgetWithText(SimuPrimaryAction, 'Claim +180 XP & Continue');
    await tester.tap(claimButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 5. Back on Home Page
    expect(find.byType(HomePage), findsOneWidget);
  });
}
