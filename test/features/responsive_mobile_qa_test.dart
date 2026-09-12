import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/drills/presentation/pages/drills_page.dart';
import 'package:simu/features/home/presentation/pages/home_page.dart';
import 'package:simu/features/journey/presentation/pages/journey_detail_page.dart';
import 'package:simu/features/journey/presentation/pages/your_journey_page.dart';
import 'package:simu/features/onboarding/presentation/pages/goal_selection_page.dart';
import 'package:simu/features/onboarding/presentation/pages/meet_ace_page.dart';
import 'package:simu/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:simu/features/practice/presentation/pages/practice_detail_page.dart';
import 'package:simu/features/practice/presentation/pages/practice_library_page.dart';
import 'package:simu/features/profile/presentation/pages/profile_page.dart';
import 'package:simu/features/progression/presentation/pages/achievements_page.dart';
import 'package:simu/features/progression/presentation/pages/challenge_history_page.dart';
import 'package:simu/features/progression/presentation/pages/progress_page.dart';
import 'package:simu/features/settings/presentation/pages/settings_page.dart';
import 'package:simu/features/simulation/presentation/pages/challenge_intro_page.dart';
import 'package:simu/features/simulation/presentation/pages/live_simulation_page.dart';
import 'package:simu/features/simulation/presentation/pages/simulation_results_page.dart';

void main() {
  const narrowSize = Size(360, 640);

  Future<void> testScreenAtNarrowWidth(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = narrowSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: widget,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
  }

  group('Mobile Responsive QA (360px width)', () {
    testWidgets('WelcomePage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const WelcomePage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('GoalSelectionPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const GoalSelectionPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('MeetAcePage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const MeetAcePage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('YourJourneyPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const YourJourneyPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('HomePage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const HomePage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('JourneyDetailPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const JourneyDetailPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('PracticeLibraryPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const PracticeLibraryPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('PracticeDetailPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(
        tester,
        const PracticeDetailPage(categoryName: 'interviews'),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('DrillsPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const DrillsPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('ChallengeIntroPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(
        tester,
        const ChallengeIntroPage(scenarioId: 'interview-tell-me-about-yourself'),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('LiveSimulationPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(
        tester,
        const LiveSimulationPage(scenarioId: 'interview-tell-me-about-yourself'),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('SimulationResultsPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(
        tester,
        const SimulationResultsPage(scenarioId: 'interview-tell-me-about-yourself'),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProgressPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const ProgressPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('ChallengeHistoryPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const ChallengeHistoryPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('AchievementsPage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const AchievementsPage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProfilePage fits 360px', (tester) async {
      await testScreenAtNarrowWidth(tester, const ProfilePage());
      expect(tester.takeException(), isNull);
    });

    testWidgets('SettingsPage fits 360px', (tester) async {
      FlutterErrorDetails? caughtDetails;
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        caughtDetails = details;
      };
      await testScreenAtNarrowWidth(tester, const SettingsPage());
      FlutterError.onError = originalOnError;
      expect(caughtDetails, isNull);
    });
  });
}
