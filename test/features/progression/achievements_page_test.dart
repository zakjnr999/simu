import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/progression/presentation/pages/achievements_page.dart';

void main() {
  testWidgets('AchievementsPage renders vault summary, category chips, and badges',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AchievementsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Achievement Vault'), findsOneWidget);
    expect(find.text('TROPHY VAULT'), findsOneWidget);
    expect(find.textContaining('All ('), findsOneWidget);
    expect(find.text('First Step Forward'), findsOneWidget);
    expect(find.text('Story Architect'), findsOneWidget);
    expect(find.text('Consistency Champion'), findsOneWidget);
    expect(find.text('UNLOCKED'), findsWidgets);
  });
}
