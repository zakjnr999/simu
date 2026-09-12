import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/core/services/analytics/analytics_service.dart';
import 'package:simu/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:simu/features/onboarding/domain/entities/daily_commitment.dart';
import 'package:simu/features/onboarding/domain/entities/experience_level.dart';
import 'package:simu/features/onboarding/domain/entities/mastery_goal.dart';
import 'package:simu/features/onboarding/domain/entities/personal_goal.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:simu/features/onboarding/presentation/state/onboarding_state.dart';

/// Riverpod Notifier provider for onboarding state.
final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(() {
  return OnboardingController();
});

class OnboardingController extends Notifier<OnboardingState> {
  OnboardingRepository get _repository =>
      ref.read(onboardingRepositoryProvider);
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  @override
  OnboardingState build() {
    return OnboardingState(
      availableGoals: UserGoal.predefinedGoals,
      selectedGoal: UserGoal.predefinedGoals.first,
      availableMasteryGoals: MasteryGoal.predefinedGoals,
      selectedMasteryGoal: MasteryGoal.predefinedGoals.first,
      availableExperienceLevels: ExperienceLevel.predefinedLevels,
      selectedExperienceLevel: ExperienceLevel.predefinedLevels.first,
      availablePersonalGoals: PersonalGoal.predefinedGoals,
      selectedPersonalGoal: PersonalGoal.predefinedGoals.first,
      availableCommitments: DailyCommitment.predefinedCommitments,
      selectedCommitment: DailyCommitment.predefinedCommitments.first,
      currentStep: 1,
    );
  }

  /// Select a practice goal category.
  void selectGoal(UserGoal goal) {
    if (state.selectedGoal?.category == goal.category) return;
    state = state.copyWith(selectedGoal: goal, clearError: true);
    _analytics.trackEvent('goal_selected', {'category': goal.category.name});
  }

  /// Select a mastery outcome (Step 2).
  void selectMasteryGoal(MasteryGoal goal) {
    if (state.selectedMasteryGoal?.id == goal.id) return;
    state = state.copyWith(selectedMasteryGoal: goal, clearError: true);
    _analytics.trackEvent('mastery_goal_selected', {'id': goal.id});
  }

  /// Select an experience level (Step 3).
  void selectExperience(ExperienceLevel level) {
    if (state.selectedExperienceLevel?.id == level.id) return;
    state = state.copyWith(selectedExperienceLevel: level, clearError: true);
    _analytics.trackEvent('experience_level_selected', {'id': level.id});
  }

  /// Select a personal/main goal (Step 4).
  void selectPersonalGoal(PersonalGoal goal) {
    if (state.selectedPersonalGoal?.id == goal.id) return;
    state = state.copyWith(selectedPersonalGoal: goal, clearError: true);
    _analytics.trackEvent('personal_goal_selected', {'id': goal.id});
  }

  /// Select a daily commitment time (Step 5).
  void selectCommitment(DailyCommitment commitment) {
    if (state.selectedCommitment?.id == commitment.id) return;
    state = state.copyWith(selectedCommitment: commitment, clearError: true);
    _analytics.trackEvent('commitment_selected', {'id': commitment.id});
  }

  /// Transition state steps
  void nextStep() {
    if (state.currentStep < 5) {
      final next = state.currentStep + 1;
      state = state.copyWith(currentStep: next);
      _analytics.trackEvent('onboarding_step_changed', {'step': next});
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      final prev = state.currentStep - 1;
      state = state.copyWith(
        currentStep: prev,
        reachedChest: false,
      );
      _analytics.trackEvent('onboarding_step_changed', {'step': prev});
    }
  }

  /// Persist onboarding and trigger chest state for the curtain handoff.
  Future<bool> completeOnboardingForTransition() async {
    state = state.copyWith(reachedChest: true, clearError: true);
    await _analytics.trackEvent('onboarding_completed_chest_arrival', {});

    final success = await saveGoalAndContinue();
    if (!success) {
      state = state.copyWith(reachedChest: false);
    }
    return success;
  }

  /// Trigger the final chest-reaching shine animation before onboarding completion.
  Future<bool> triggerChestArrival() async {
    final success = await completeOnboardingForTransition();
    if (!success) {
      return false;
    }

    await Future<void>.delayed(const Duration(milliseconds: 1800));
    return true;
  }

  /// Persist all selected onboarding values to storage and continue.
  Future<bool> saveGoalAndContinue() async {
    final goal = state.selectedGoal;
    final masteryGoal = state.selectedMasteryGoal;
    final experience = state.selectedExperienceLevel;
    final personalGoal = state.selectedPersonalGoal;
    final commitment = state.selectedCommitment;

    if (goal == null ||
        masteryGoal == null ||
        experience == null ||
        personalGoal == null ||
        commitment == null) {
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    // 1. Save Goal Category
    final goalRes = await _repository.saveSelectedGoal(goal.category);
    return goalRes.when(
      onSuccess: (_) async {
        // 2. Save Mastery Goal
        final masteryRes = await _repository.saveSelectedMasteryGoal(masteryGoal.id);
        return masteryRes.when(
          onSuccess: (_) async {
            // 3. Save Experience Level
            final expRes = await _repository.saveSelectedExperience(experience.id);
            return expRes.when(
              onSuccess: (_) async {
                // 4. Save Personal Goal
                final pGoalRes = await _repository.saveSelectedPersonalGoal(personalGoal.id);
                return pGoalRes.when(
                  onSuccess: (_) async {
                    // 5. Save Daily Commitment
                    final commRes = await _repository.saveSelectedCommitment(commitment.id);
                    return commRes.when(
                      onSuccess: (_) {
                        state = state.copyWith(isLoading: false);
                        return true;
                      },
                      onFailure: (failure) {
                        state = state.copyWith(isLoading: false, errorMessage: failure.message);
                        return false;
                      },
                    );
                  },
                  onFailure: (failure) {
                    state = state.copyWith(isLoading: false, errorMessage: failure.message);
                    return false;
                  },
                );
              },
              onFailure: (failure) {
                state = state.copyWith(isLoading: false, errorMessage: failure.message);
                return false;
              },
            );
          },
          onFailure: (failure) {
            state = state.copyWith(isLoading: false, errorMessage: failure.message);
            return false;
          },
        );
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }
}
