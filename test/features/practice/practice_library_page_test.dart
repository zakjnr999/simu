import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/practice/presentation/pages/practice_library_page.dart';
import 'package:simu/features/practice/presentation/widgets/practice_category_card.dart';

void main() {
  testWidgets('PracticeLibraryPage renders categories, primary highlight, and filters',
      (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PracticeLibraryPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify hero and highlights
    expect(find.text('ALL PRACTICE CATEGORIES'), findsOneWidget);
    expect(find.text('YOUR MAIN FOCUS'), findsOneWidget);

    // Verify initial cards
    expect(find.text('Interview Mastery'), findsWidgets);
    expect(find.text('Clear Communication'), findsWidgets);

    // Tap Interview filter chip
    final interviewFilter = find.textContaining('Interview Mastery').first;
    await tester.tap(interviewFilter);
    await tester.pumpAndSettle();

    // Verify filtered to 1 card
    expect(find.byType(PracticeCategoryCard), findsOneWidget);
    expect(find.text('Interview Mastery'), findsWidgets);

    // Switch back to All filter
    final allFilter = find.textContaining('All (4)').first;
    await tester.tap(allFilter);
    await tester.pumpAndSettle();

    // Verify cards returned
    expect(find.byType(PracticeCategoryCard), findsNWidgets(4));
  });
}
