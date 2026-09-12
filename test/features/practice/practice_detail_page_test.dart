import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/practice/presentation/pages/practice_detail_page.dart';
import 'package:simu/features/practice/presentation/widgets/practice_challenge_tile.dart';

void main() {
  testWidgets('PracticeDetailPage renders interview category with challenges and competencies',
      (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PracticeDetailPage(categoryName: 'interviews'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify header and overview
    expect(find.text('Interview Mastery'), findsWidgets);
    expect(find.text('TARGET COMPETENCIES'), findsOneWidget);
    expect(find.text('Present-Past-Future'), findsWidgets);
    expect(find.text('STAR Framework'), findsOneWidget);
    expect(find.textContaining('AVAILABLE CHALLENGES'), findsOneWidget);

    // Verify challenge tiles
    expect(find.byType(PracticeChallengeTile), findsWidgets);
    expect(find.text('Opening Pitch & Warmup'), findsWidgets);
    expect(find.text('Start Challenge'), findsWidgets);
  });

  testWidgets('PracticeDetailPage adapts cleanly to communication category',
      (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PracticeDetailPage(categoryName: 'communication'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Clear Communication'), findsWidgets);
    expect(find.text('Executive Empathy'), findsOneWidget);
    expect(find.text('Explain a Difficult Idea Simply'), findsWidgets);
    expect(find.text('Replay Practice'), findsWidgets);
  });
}
