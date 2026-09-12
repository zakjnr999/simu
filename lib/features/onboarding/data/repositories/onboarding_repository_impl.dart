import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/core/constants/app_constants.dart';
import 'package:simu/core/errors/app_failure.dart';
import 'package:simu/core/result/result.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Provider for OnboardingRepository.
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final storage = ref.watch(keyValueStorageProvider);
  return OnboardingRepositoryImpl(storage: storage);
});

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl({required this.storage});

  final KeyValueStorage storage;

  @override
  Future<Result<void, AppFailure>> saveSelectedGoal(
      UserGoalCategory category) async {
    try {
      await storage.setString(AppConstants.keySelectedGoal, category.name);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Failed to save selected goal: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<UserGoalCategory?, AppFailure>> getSelectedGoal() async {
    try {
      final name = await storage.getString(AppConstants.keySelectedGoal);
      if (name == null) return const Result.success(null);
      final category = UserGoalCategory.values.firstWhere(
        (c) => c.name == name,
        orElse: () => UserGoalCategory.interviews,
      );
      return Result.success(category);
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Failed to load selected goal: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedMasteryGoal(
      String masteryGoalId) async {
    try {
      await storage.setString(AppConstants.keySelectedMasteryGoal, masteryGoalId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to save selected mastery goal: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedMasteryGoal() async {
    try {
      final id = await storage.getString(AppConstants.keySelectedMasteryGoal);
      return Result.success(id);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to load selected mastery goal: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedExperience(
      String experienceId) async {
    try {
      await storage.setString(AppConstants.keySelectedExperience, experienceId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to save selected experience: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedExperience() async {
    try {
      final id = await storage.getString(AppConstants.keySelectedExperience);
      return Result.success(id);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to load selected experience: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedPersonalGoal(
      String personalGoalId) async {
    try {
      await storage.setString(AppConstants.keySelectedPersonalGoal, personalGoalId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to save selected personal goal: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedPersonalGoal() async {
    try {
      final id = await storage.getString(AppConstants.keySelectedPersonalGoal);
      return Result.success(id);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to load selected personal goal: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> saveSelectedCommitment(
      String commitmentId) async {
    try {
      await storage.setString(AppConstants.keySelectedCommitment, commitmentId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to save selected commitment: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<String?, AppFailure>> getSelectedCommitment() async {
    try {
      final id = await storage.getString(AppConstants.keySelectedCommitment);
      return Result.success(id);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to load selected commitment: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> completeOnboarding() async {
    try {
      await storage.setBool(AppConstants.keyOnboardingComplete, true);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageFailure(message: 'Failed to complete onboarding: $e', cause: e),
      );
    }
  }

  @override
  Future<Result<bool, AppFailure>> isOnboardingComplete() async {
    try {
      final isComplete =
          await storage.getBool(AppConstants.keyOnboardingComplete);
      return Result.success(isComplete ?? false);
    } catch (e) {
      return Result.failure(
        StorageFailure(
            message: 'Failed to check onboarding status: $e', cause: e),
      );
    }
  }
}
