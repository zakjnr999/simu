import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/features/common/presentation/pages/simu_placeholder_page.dart';
import 'package:simu/features/drills/presentation/pages/drills_page.dart';
import 'package:simu/features/home/presentation/pages/home_page.dart';
import 'package:simu/features/home/presentation/widgets/main_shell_scaffold.dart';
import 'package:simu/features/journey/presentation/pages/journey_detail_page.dart';
import 'package:simu/features/journey/presentation/pages/your_journey_page.dart';
import 'package:simu/features/onboarding/presentation/pages/goal_selection_page.dart';
import 'package:simu/features/onboarding/presentation/pages/meet_ace_page.dart';
import 'package:simu/features/onboarding/presentation/pages/splash_page.dart';
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

Page<void> _mainTabPage({
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<void>(
    key: state.pageKey,
    child: child,
  );
}

/// Provider for the application's GoRouter instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding Flow
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomePage(),
        routes: [
          GoRoute(
            path: 'goal',
            builder: (context, state) => const GoalSelectionPage(),
          ),
          GoRoute(
            path: 'experience',
            builder: (context, state) =>
                const SimuPlaceholderPage(routeName: '/onboarding/experience'),
          ),
          GoRoute(
            path: 'personal-goal',
            builder: (context, state) => const SimuPlaceholderPage(
                routeName: '/onboarding/personal-goal'),
          ),
          GoRoute(
            path: 'commitment',
            builder: (context, state) =>
                const SimuPlaceholderPage(routeName: '/onboarding/commitment'),
          ),
          GoRoute(
            path: 'mascot',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const MeetAcePage(),
            ),
          ),
          GoRoute(
            path: 'journey',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const YourJourneyPage(),
            ),
          ),
          GoRoute(
            path: 'how-it-works',
            builder: (context, state) => const SimuPlaceholderPage(
                routeName: '/onboarding/how-it-works'),
          ),
          GoRoute(
            path: 'first-challenge',
            builder: (context, state) => const SimuPlaceholderPage(
                routeName: '/onboarding/first-challenge'),
          ),
        ],
      ),

      // Main app tabs — shell keeps bottom nav alive for indicator animations.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShellScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                pageBuilder: (context, state) => _mainTabPage(
                  state: state,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.journeyHub,
                pageBuilder: (context, state) => _mainTabPage(
                  state: state,
                  child: const JourneyDetailPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.practice,
                pageBuilder: (context, state) => _mainTabPage(
                  state: state,
                  child: const PracticeLibraryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                pageBuilder: (context, state) => _mainTabPage(
                  state: state,
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Practice detail routes (outside main tab shell)
      GoRoute(
        path: RouteNames.practiceCategory,
        builder: (context, state) => PracticeDetailPage(
          categoryName: state.pathParameters['category'] ?? 'interviews',
        ),
      ),
      GoRoute(
        path: RouteNames.practiceScenario,
        builder: (context, state) => SimuPlaceholderPage(
          routeName:
              '/practice/${state.pathParameters['category']}/${state.pathParameters['scenario']}',
        ),
      ),

      // Simulation
      GoRoute(
        path: RouteNames.simulationIntro,
        builder: (context, state) => ChallengeIntroPage(
          scenarioId: state.pathParameters['id'] ?? 'interview-tell-me-about-yourself',
        ),
      ),
      GoRoute(
        path: RouteNames.simulation,
        builder: (context, state) => LiveSimulationPage(
          scenarioId: state.pathParameters['id'] ?? 'interview-tell-me-about-yourself',
        ),
      ),
      GoRoute(
        path: RouteNames.simulationResults,
        builder: (context, state) => SimulationResultsPage(
          scenarioId: state.pathParameters['id'] ?? 'interview-tell-me-about-yourself',
        ),
      ),

      // Secondary Core Routes
      GoRoute(
        path: RouteNames.drills,
        builder: (context, state) => const DrillsPage(),
      ),
      GoRoute(
        path: RouteNames.progress,
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: RouteNames.challengeHistory,
        builder: (context, state) => const ChallengeHistoryPage(),
      ),
      GoRoute(
        path: RouteNames.achievements,
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) =>
            const SimuPlaceholderPage(routeName: '/auth/login'),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) =>
            const SimuPlaceholderPage(routeName: '/auth/signup'),
      ),
    ],
  );
});
