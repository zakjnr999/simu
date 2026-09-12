import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/design_system/components/cards/simu_selectable_card.dart';

void main() {
  group('SimuSelectableCard Widget Tests', () {
    testWidgets('renders title, description and triggers onTap callback',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuSelectableCard(
              title: 'Interviews',
              description: 'Practice behavioral and technical questions',
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Interviews'), findsOneWidget);
      expect(find.text('Practice behavioral and technical questions'),
          findsOneWidget);
      expect(find.byIcon(LucideIcons.check), findsNothing);

      await tester.tap(find.text('Interviews'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('displays checkmark when isSelected is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuSelectableCard(
              title: 'Negotiation',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Negotiation'), findsOneWidget);
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
    });
  });
}
