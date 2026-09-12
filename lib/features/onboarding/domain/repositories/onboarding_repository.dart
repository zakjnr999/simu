import 'package:simu/core/errors/app_failure.dart';
import 'package:simu/core/result/result.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';

/// Repository contract for onboarding persistence and retrieval.
abstract class OnboardingRepository {
  Future<Result<void, AppFailure>> saveSelectedGoal(UserGoalCategory category);
  Future<Result<UserGoalCategory?, AppFailure>> getSelectedGoal();
  Future<Result<void, AppFailure>> saveSelectedMasteryGoal(String masteryGoalId);
  Future<Result<String?, AppFailure>> getSelectedMasteryGoal();
  Future<Result<void, AppFailure>> saveSelectedExperience(String experienceId);
  Future<Result<String?, AppFailure>> getSelectedExperience();
  Future<Result<void, AppFailure>> saveSelectedPersonalGoal(String personalGoalId);
  Future<Result<String?, AppFailure>> getSelectedPersonalGoal();
  Future<Result<void, AppFailure>> saveSelectedCommitment(String commitmentId);
  Future<Result<String?, AppFailure>> getSelectedCommitment();
  Future<Result<void, AppFailure>> completeOnboarding();
  Future<Result<bool, AppFailure>> isOnboardingComplete();
}

