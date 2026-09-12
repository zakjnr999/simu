import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/features/practice/presentation/pages/practice_detail_page.dart';
import 'package:simu/features/practice/presentation/pages/practice_library_page.dart';
import 'package:simu/features/simulation/presentation/pages/challenge_intro_page.dart';

void main() {
  testWidgets('Multi-Practice Flow: Library -> Category Detail -> Start Challenge (Intro)',
      (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: RouteNames.practice,
      routes: [
        GoRoute(
          path: RouteNames.practice,
          builder: (context, state) => const PracticeLibraryPage(),
        ),
        GoRoute(
          path: RouteNames.practiceCategory,
          builder: (context, state) => PracticeDetailPage(
            categoryName: state.pathParameters['category'] ?? 'communication',
          ),
        ),
        GoRoute(
          path: RouteNames.simulationIntro,
          builder: (context, state) => ChallengeIntroPage(
            scenarioId: state.pathParameters['id'] ?? 'communication-speak-clearly',
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

    // 1. On Practice Library
    expect(find.text('ALL PRACTICE CATEGORIES'), findsOneWidget);
    expect(find.text('Clear Communication'), findsWidgets);

    // 2. Tap Clear Communication card
    final commCard = find.text('Clear Communication').first;
    await tester.tap(commCard);
    await tester.pumpAndSettle();

    // 3. On Practice Detail Page
    expect(find.byType(PracticeDetailPage), findsOneWidget);
    expect(find.text('Explain a Difficult Idea Simply'), findsWidgets);

    // 4. Tap Replay Practice / Start Challenge
    final startButton = find.text('Replay Practice').first;
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // 5. Arrive at ChallengeIntroPage for that scenario
    expect(find.byType(ChallengeIntroPage), findsOneWidget);
    expect(find.text('Mission Brief'), findsOneWidget);
    expect(find.text('Explain a Difficult Idea Simply'), findsWidgets);
  });
}
