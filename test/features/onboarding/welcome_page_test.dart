import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/core/errors/app_failure.dart';
import 'package:simu/core/result/result.dart';
import 'package:simu/core/services/analytics/analytics_service.dart';
import 'package:simu/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:simu/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_hero_section.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_practice_section.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_progress_path.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_social_proof.dart';

class FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> setCurrentScreen(String screenName) async {}
  @override
  Future<void> setUserId(String? userId) async {}
  @override
  Future<void> setUserProperty(String name, String value) async {}
  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? parameters]) async {}
}

class FakeOnboardingRepository implements OnboardingRepository {
  @override
  Future<Result<void, AppFailure>> completeOnboarding() async =>
      const Result.success(null);
  @override
  Future<Result<UserGoalCategory?, AppFailure>> getSelectedGoal() async =>
      const Result.success(UserGoalCategory.interviews);
  @override
  Future<Result<void, AppFailure>> saveSelectedMasteryGoal(
          String masteryGoalId) async =>
      const Result.success(null);
  @override
  Future<Result<String?, AppFailure>> getSelectedMasteryGoal() async =>
      const Result.success(null);
  @override
  Future<Result<void, AppFailure>> saveSelectedExperience(
          String experienceId) async =>
      const Result.success(null);
  @override
  Future<Result<String?, AppFailure>> getSelectedExperience() async =>
      const Result.success(null);
  @override
  Future<Result<void, AppFailure>> saveSelectedPersonalGoal(
          String personalGoalId) async =>
      const Result.success(null);
  @override
  Future<Result<String?, AppFailure>> getSelectedPersonalGoal() async =>
      const Result.success(null);
  @override
  Future<Result<void, AppFailure>> saveSelectedCommitment(
          String commitmentId) async =>
      const Result.success(null);
  @override
  Future<Result<String?, AppFailure>> getSelectedCommitment() async =>
      const Result.success(null);
  @override
  Future<Result<bool, AppFailure>> isOnboardingComplete() async =>
      const Result.success(false);
  @override
  Future<Result<void, AppFailure>> saveSelectedGoal(
          UserGoalCategory category) async =>
      const Result.success(null);
}

void main() {
  testWidgets('WelcomePage renders all approved reference sections',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
          onboardingRepositoryProvider
              .overrideWithValue(FakeOnboardingRepository()),
        ],
        child: const MaterialApp(
          home: WelcomePage(),
        ),
      ),
    );

    // Hero Section
    expect(find.byType(OnboardingHeroSection), findsOneWidget);
    expect(find.textContaining('Ace'), findsOneWidget);

    // Progression Path
    expect(find.byType(OnboardingProgressPath), findsOneWidget);
    expect(find.text('Your best\nversion!'), findsOneWidget);

    // Practice Section with 4 categories
    expect(find.byType(OnboardingPracticeSection), findsOneWidget);
    expect(find.text('Interviews'), findsOneWidget);
    expect(find.text('Communication'), findsOneWidget);
    expect(find.text('Negotiation'), findsOneWidget);
    expect(find.text('Technical'), findsOneWidget);

    // Primary CTA
    expect(find.byType(OnboardingPrimaryCta), findsOneWidget);
    expect(find.text("Let's Begin the Journey!"), findsOneWidget);

    // Social Proof
    expect(find.byType(OnboardingSocialProof), findsOneWidget);
    expect(find.text('2.4K+ learners'), findsOneWidget);
  });

  testWidgets('WelcomePage keeps stepper, cards, and CTA pinned across steps',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
          onboardingRepositoryProvider
              .overrideWithValue(FakeOnboardingRepository()),
        ],
        child: const MaterialApp(
          home: WelcomePage(),
        ),
      ),
    );

    Offset topOf(Finder finder) => tester.getTopLeft(finder);

    final step1Cta = topOf(find.byType(OnboardingPrimaryCta));

    await tester.tap(find.text("Let's Begin the Journey!"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(topOf(find.byType(OnboardingPrimaryCta)).dy, step1Cta.dy);

    await tester.tap(find.text('Continue My Journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(topOf(find.byType(OnboardingPrimaryCta)).dy, step1Cta.dy);
  });
}
