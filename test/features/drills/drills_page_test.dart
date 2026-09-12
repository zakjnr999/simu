import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/features/drills/presentation/pages/drills_page.dart';
import 'package:simu/features/simulation/presentation/pages/challenge_intro_page.dart';

void main() {
  testWidgets('DrillsPage renders micro-drills, filters, and launches challenge intro',
      (tester) async {
    tester.view.physicalSize = const Size(600, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: RouteNames.drills,
      routes: [
        GoRoute(
          path: RouteNames.drills,
          builder: (context, state) => const DrillsPage(),
        ),
        GoRoute(
          path: RouteNames.simulationIntro,
          builder: (context, state) => ChallengeIntroPage(
            scenarioId: state.pathParameters['id'] ?? 'interview-tell-me-about-yourself',
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify header and Ace coach tip
    expect(find.text('Targeted Drills'), findsOneWidget);
    expect(find.textContaining('Micro-drills sharpen muscle memory'), findsOneWidget);

    // Verify initial drills
    expect(find.text('STAR Method Rapid Fire'), findsOneWidget);
    expect(find.text('30-Second Executive Pitch'), findsOneWidget);

    // Filter by Negotiation
    final negFilter = find.text('🤝 Negotiation');
    await tester.tap(negFilter);
    await tester.pumpAndSettle();

    // Verify filtered drill
    expect(find.text('Salary Anchor Rebuttal'), findsOneWidget);
    expect(find.text('STAR Method Rapid Fire'), findsNothing);

    // Start Drill
    final startButton = find.textContaining('Start Micro-Drill').first;
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Verify arrived at ChallengeIntroPage
    expect(find.byType(ChallengeIntroPage), findsOneWidget);
    expect(find.text('Mission Brief'), findsOneWidget);
  });
}
