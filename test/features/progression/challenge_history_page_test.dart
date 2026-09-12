import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/progression/presentation/pages/challenge_history_page.dart';

void main() {
  testWidgets('ChallengeHistoryPage renders filters and past session cards',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ChallengeHistoryPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Practice History'), findsOneWidget);
    expect(find.textContaining('All ('), findsOneWidget);
    expect(find.textContaining('Completed ('), findsOneWidget);
    expect(find.text('Tell Me About Yourself'), findsOneWidget);
    expect(find.text('Explain a Difficult Idea Simply'), findsOneWidget);
    expect(find.text('Review Feedback'), findsWidgets);
    expect(find.text('Replay Practice'), findsWidgets);
  });
}
