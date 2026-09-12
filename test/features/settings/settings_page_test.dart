import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/settings/presentation/pages/settings_page.dart';

void main() {
  testWidgets('SettingsPage renders sections, switches, and delete confirmation',
      (tester) async {
    tester.view.physicalSize = const Size(500, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsPage(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify headers
    expect(find.text('Settings & Privacy'), findsOneWidget);
    expect(find.text('PRACTICE REMINDER SCHEDULE'), findsOneWidget);
    expect(find.text('SPEECH & INTERACTION'), findsOneWidget);
    expect(find.text('PRIVACY & DATA GOVERNANCE'), findsOneWidget);
    expect(find.text('ACCOUNT & MEMBERSHIP'), findsOneWidget);

    // Verify interactive switches
    expect(find.text('Daily Practice Reminders'), findsOneWidget);
    expect(find.text('Voice Dictation Input'), findsOneWidget);

    // Tap Delete Account tile to open dialog
    final deleteTile = find.text('Delete Account & Data');
    await tester.tap(deleteTile);
    await tester.pumpAndSettle();

    // Verify dialog opened
    expect(find.text('Delete Account & Data?'), findsOneWidget);
    expect(find.text('Delete Everything'), findsOneWidget);

    // Dismiss dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Account & Data?'), findsNothing);
  });
}
