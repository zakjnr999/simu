import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/design_system/components/states/simu_empty_state.dart';

void main() {
  group('Consolidated Design System Components', () {
    testWidgets('SimuTactileCard renders child and fires onTap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuTactileCard(
              onTap: () => tapped = true,
              child: const Text('Tactile Content'),
            ),
          ),
        ),
      );

      expect(find.text('Tactile Content'), findsOneWidget);
      await tester.tap(find.text('Tactile Content'));
      expect(tapped, isTrue);
    });

    testWidgets('SimuEmptyState renders title, description, and triggers onAction',
        (tester) async {
      bool actionTriggered = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuEmptyState(
              title: 'Empty List',
              description: 'Nothing to see here right now.',
              actionLabel: 'Add Item',
              onAction: () => actionTriggered = true,
            ),
          ),
        ),
      );

      expect(find.text('Empty List'), findsOneWidget);
      expect(find.text('Nothing to see here right now.'), findsOneWidget);
      expect(find.text('Add Item'), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      expect(actionTriggered, isTrue);
    });

    testWidgets('SimuMascotGuidanceBar renders Ace and speech bubble',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SimuMascotGuidanceBar(
              message: 'Ace gives great advice!',
            ),
          ),
        ),
      );

      expect(find.text('Ace gives great advice!'), findsOneWidget);
      expect(find.byType(SimuMascotGuidanceBar), findsOneWidget);
    });
  });
}
