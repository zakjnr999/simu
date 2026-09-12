import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/progression/presentation/pages/progress_page.dart';

void main() {
  testWidgets('ProgressPage renders level hero, streak tracker, skills, and achievements',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProgressPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Growth & Stats'), findsOneWidget);
    expect(find.text('Rising Communicator'), findsOneWidget);
    expect(find.text('WEEKLY CONSISTENCY'), findsOneWidget);
    expect(find.text('CORE COMPETENCIES'), findsOneWidget);
    expect(find.text('Clarity & Structure'), findsOneWidget);
    expect(find.text('Executive Presence'), findsOneWidget);
    expect(find.text('ACHIEVEMENTS'), findsOneWidget);
    expect(find.text('RECENT PRACTICE SESSIONS'), findsOneWidget);
    expect(find.text('View Practice History'), findsOneWidget);
  });
}
