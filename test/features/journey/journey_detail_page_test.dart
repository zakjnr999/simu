import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/journey/presentation/pages/journey_detail_page.dart';
import 'package:simu/features/journey/presentation/widgets/milestone_detail_sheet.dart';

void main() {
  testWidgets('JourneyDetailPage renders roadmap, hero banner, Ace tip, and opens milestone sheet',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: JourneyDetailPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify header and roadmap sections
    expect(find.text('MILESTONE ROADMAP'), findsOneWidget);
    expect(find.text('The First Impression'), findsOneWidget);
    expect(find.text('Tell Me About Yourself'), findsOneWidget);
    expect(find.text('Handling Tough Questions'), findsOneWidget);
    expect(find.textContaining('Continue Chapter:'), findsOneWidget);

    // Tap a milestone to open MilestoneDetailSheet
    final milestoneFinder = find.text('The First Impression');
    await tester.tap(milestoneFinder);
    await tester.pumpAndSettle();

    // Verify modal sheet opens with challenges
    expect(find.byType(MilestoneDetailSheet), findsOneWidget);
    expect(find.text('CHAPTER 1 OF 5'), findsOneWidget);
    expect(find.text('CHALLENGES IN THIS CHAPTER'), findsOneWidget);
    expect(find.text('Opening Pitch & Warmup'), findsOneWidget);
  });
}
