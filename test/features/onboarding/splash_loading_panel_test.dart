import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/onboarding/presentation/widgets/splash_loading_panel.dart';

void main() {
  group('SplashLoadingPanel Widget Tests', () {
    testWidgets(
        'renders status message, formatted percentage, and 3 paw indicators',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SplashLoadingPanel(
              progress: 0.55,
              statusMessage: 'Preparing your adventure...',
            ),
          ),
        ),
      );

      expect(find.text('Preparing your adventure...'), findsOneWidget);
      expect(find.text('55%'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(3));
    });

    testWidgets('clamps progress and displays 100% when progress is 1.0',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SplashLoadingPanel(
              progress: 1.0,
              statusMessage: 'Ready to level up!',
            ),
          ),
        ),
      );

      expect(find.text('Ready to level up!'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });
  });
}
