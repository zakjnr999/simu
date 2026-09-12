import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/home/domain/simu_nav_destination.dart';
import 'package:simu/features/home/presentation/widgets/simu_bottom_nav_bar.dart';

void main() {
  testWidgets('SimuBottomNavBar renders tabs and center paw asset', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimuBottomNavBar(
            current: SimuNavDestination.home,
            onDestinationSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Journey'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.home), findsNothing);
  });

  testWidgets('SimuBottomNavBar calls onDestinationSelected', (tester) async {
  SimuNavDestination? tapped;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimuBottomNavBar(
            current: SimuNavDestination.home,
            onDestinationSelected: (destination) => tapped = destination,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Practice'));
    await tester.pump();

    expect(tapped, SimuNavDestination.practice);
  });

  testWidgets('SimuBottomNavBar slides indicator when tab changes', (tester) async {
    Future<void> pumpNav(SimuNavDestination current) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimuBottomNavBar(
              current: current,
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      );
    }

    await pumpNav(SimuNavDestination.home);
    final homeLeft = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('simu_nav_indicator')),
    ).left;

    await pumpNav(SimuNavDestination.journey);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 125));

    final journeyLeft = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('simu_nav_indicator')),
    ).left;

    expect(journeyLeft, greaterThan(homeLeft!));
  });
}
