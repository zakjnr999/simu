import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';

void main() {
  group('SimuPrimaryAction Widget Tests', () {
    testWidgets('renders label and triggers onPressed', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuPrimaryAction(
              label: 'Continue',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets(
        'shows loading indicator when isLoading is true and ignores tap',
        (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuPrimaryAction(
              label: 'Continue',
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continue'), findsNothing);

      await tester.tap(find.byType(CircularProgressIndicator));
      await tester.pump(const Duration(milliseconds: 50));

      expect(pressed, isFalse);
    });
  });
}
