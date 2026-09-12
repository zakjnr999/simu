import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/core/errors/app_failure.dart';
import 'package:simu/core/result/result.dart';
import 'package:simu/core/services/analytics/analytics_service.dart';
import 'package:simu/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';

class MockOnboardingRepository implements OnboardingRepository {
  UserGoalCategory? savedCategory;
  String? savedMasteryGoalId;
  String? savedExperienceId;
  String? savedPersonalGoalId;
  String? savedCommitmentId;
  bool isCompleted = false;

  @override
  Future<Result<void, AppFailure>> saveSelectedGoal(
      UserGoalCategory category) async {
    savedCategory = category;
    return const Result.success(null);
  }

  @override
  Future<Result<UserGoalCategory?, AppFailure>> getSelectedGoal() async {
    return Result.success(savedCategory);
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedMasteryGoal(
      String masteryGoalId) async {
    savedMasteryGoalId = masteryGoalId;
    return const Result.success(null);
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedMasteryGoal() async {
    return Result.success(savedMasteryGoalId);
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedExperience(
      String experienceId) async {
    savedExperienceId = experienceId;
    return const Result.success(null);
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedExperience() async {
    return Result.success(savedExperienceId);
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedPersonalGoal(
      String personalGoalId) async {
    savedPersonalGoalId = personalGoalId;
    return const Result.success(null);
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedPersonalGoal() async {
    return Result.success(savedPersonalGoalId);
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedCommitment(
      String commitmentId) async {
    savedCommitmentId = commitmentId;
    return const Result.success(null);
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedCommitment() async {
    return Result.success(savedCommitmentId);
  }

  @override
  Future<Result<void, AppFailure>> completeOnboarding() async {
    isCompleted = true;
    return const Result.success(null);
  }

  @override
  Future<Result<bool, AppFailure>> isOnboardingComplete() async {
    return Result.success(isCompleted);
  }
}

class MockAnalyticsService implements AnalyticsService {
  final List<String> trackedEvents = [];

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? parameters]) async {
    trackedEvents.add(eventName);
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {}

  @override
  Future<void> setUserProperty(String name, String value) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}

void main() {
  group('OnboardingController Tests', () {
    late MockOnboardingRepository mockRepository;
    late MockAnalyticsService mockAnalytics;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockOnboardingRepository();
      mockAnalytics = MockAnalyticsService();
      container = ProviderContainer(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(mockRepository),
          analyticsServiceProvider.overrideWithValue(mockAnalytics),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
        'initial state contains the 4 approved goal categories and defaults to Interviews',
        () {
      final state = container.read(onboardingControllerProvider);

      expect(state.availableGoals.length, 4);
      expect(
        state.availableGoals.map((g) => g.category),
        containsAll([
          UserGoalCategory.interviews,
          UserGoalCategory.communication,
          UserGoalCategory.negotiation,
          UserGoalCategory.technical,
        ]),
      );
      expect(state.selectedGoal?.category, equals(UserGoalCategory.interviews));
      expect(state.hasSelection, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('selectGoal updates selectedGoal and tracks analytics event', () {
      final controller = container.read(onboardingControllerProvider.notifier);
      final commGoal = UserGoal.predefinedGoals.firstWhere(
        (g) => g.category == UserGoalCategory.communication,
      );

      controller.selectGoal(commGoal);

      final state = container.read(onboardingControllerProvider);
      expect(state.selectedGoal, equals(commGoal));
      expect(state.hasSelection, isTrue);
      expect(mockAnalytics.trackedEvents, contains('goal_selected'));
    });

    test('saveGoalAndContinue successfully persists goal to repository',
        () async {
      final controller = container.read(onboardingControllerProvider.notifier);
      final negotiationGoal = UserGoal.predefinedGoals.firstWhere(
        (g) => g.category == UserGoalCategory.negotiation,
      );

      controller.selectGoal(negotiationGoal);
      final success = await controller.saveGoalAndContinue();

      expect(success, isTrue);
      expect(
          mockRepository.savedCategory, equals(UserGoalCategory.negotiation));
      final state = container.read(onboardingControllerProvider);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('previousStep clears reachedChest so the progress flag can return',
        () {
      final controller = container.read(onboardingControllerProvider.notifier);

      controller.nextStep();
      controller.nextStep();
      controller.nextStep();
      controller.nextStep();
      expect(container.read(onboardingControllerProvider).currentStep, 5);

      controller.state = controller.state.copyWith(reachedChest: true);
      expect(container.read(onboardingControllerProvider).reachedChest, isTrue);

      controller.previousStep();

      final state = container.read(onboardingControllerProvider);
      expect(state.currentStep, 4);
      expect(state.reachedChest, isFalse);
    });
  });
}
