import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/features/profile/presentation/pages/profile_page.dart';
import 'package:simu/features/progression/presentation/pages/progress_page.dart';

void main() {
  testWidgets('ProfilePage renders user identity, goal track, shortcuts, and switches',
      (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Identity Hero
    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.textContaining('LEVEL'), findsWidgets);
    expect(find.textContaining('Streak'), findsWidgets);

    // Verify Primary Learning Track Card
    expect(find.text('PRIMARY LEARNING TRACK'), findsOneWidget);
    expect(find.text('Interview Mastery'), findsWidgets);

    // Verify Growth & Collections shortcuts
    expect(find.text('GROWTH & COLLECTIONS'), findsOneWidget);
    expect(find.text('My Growth & Stats'), findsOneWidget);
    expect(find.text('Practice History'), findsOneWidget);
    expect(find.text('Trophy Vault'), findsOneWidget);

    // Verify Practice Preferences Switches
    expect(find.text('PRACTICE PREFERENCES'), findsOneWidget);
    expect(find.text('Tactile Haptic Feedback'), findsOneWidget);
    expect(find.text('Voice Dictation Input'), findsOneWidget);

    // Toggle a switch
    final firstSwitch = find.byType(Switch).first;
    await tester.tap(firstSwitch);
    await tester.pumpAndSettle();

    // Verify app info
    expect(find.textContaining('Simu v1.0.0'), findsOneWidget);
  });

  testWidgets('ProfilePage shortcut opens ProgressPage', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: RouteNames.profile,
      routes: [
        GoRoute(
          path: RouteNames.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: RouteNames.progress,
          builder: (context, state) => const ProgressPage(),
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

    final progressShortcut = find.text('My Growth & Stats');
    await tester.tap(progressShortcut);
    await tester.pumpAndSettle();

    expect(find.byType(ProgressPage), findsOneWidget);
    expect(
      find.text('Track your simulation mastery and milestone achievements'),
      findsOneWidget,
    );
  });
}
