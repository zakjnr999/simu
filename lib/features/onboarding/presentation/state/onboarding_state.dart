import 'package:simu/features/onboarding/domain/entities/daily_commitment.dart';
import 'package:simu/features/onboarding/domain/entities/experience_level.dart';
import 'package:simu/features/onboarding/domain/entities/mastery_goal.dart';
import 'package:simu/features/onboarding/domain/entities/personal_goal.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';

/// Presentation state for the onboarding goal selection flow.
class OnboardingState {
  const OnboardingState({
    required this.availableGoals,
    this.selectedGoal,
    required this.availableMasteryGoals,
    this.selectedMasteryGoal,
    required this.availableExperienceLevels,
    this.selectedExperienceLevel,
    required this.availablePersonalGoals,
    this.selectedPersonalGoal,
    required this.availableCommitments,
    this.selectedCommitment,
    this.currentStep = 1,
    this.isLoading = false,
    this.errorMessage,
    this.reachedChest = false,
  });

  final List<UserGoal> availableGoals;
  final UserGoal? selectedGoal;
  final List<MasteryGoal> availableMasteryGoals;
  final MasteryGoal? selectedMasteryGoal;
  final List<ExperienceLevel> availableExperienceLevels;
  final ExperienceLevel? selectedExperienceLevel;
  final List<PersonalGoal> availablePersonalGoals;
  final PersonalGoal? selectedPersonalGoal;
  final List<DailyCommitment> availableCommitments;
  final DailyCommitment? selectedCommitment;
  final int currentStep;
  final bool isLoading;
  final String? errorMessage;
  final bool reachedChest;

  bool get hasSelection => selectedGoal != null;
  bool get hasMasterySelection => selectedMasteryGoal != null;

  /// Total XP earned from all onboarding selections.
  int get totalOnboardingXp {
    var total = 0;
    if (selectedGoal != null) total += selectedGoal!.xpBonus;
    if (selectedMasteryGoal != null) total += selectedMasteryGoal!.xpBonus;
    if (selectedExperienceLevel != null) {
      total += selectedExperienceLevel!.xpBonus;
    }
    if (selectedPersonalGoal != null) total += selectedPersonalGoal!.xpBonus;
    if (selectedCommitment != null) total += selectedCommitment!.xpBonus;
    return total;
  }

  OnboardingState copyWith({
    List<UserGoal>? availableGoals,
    UserGoal? selectedGoal,
    bool clearSelectedGoal = false,
    List<MasteryGoal>? availableMasteryGoals,
    MasteryGoal? selectedMasteryGoal,
    bool clearSelectedMasteryGoal = false,
    List<ExperienceLevel>? availableExperienceLevels,
    ExperienceLevel? selectedExperienceLevel,
    bool clearSelectedExperienceLevel = false,
    List<PersonalGoal>? availablePersonalGoals,
    PersonalGoal? selectedPersonalGoal,
    bool clearSelectedPersonalGoal = false,
    List<DailyCommitment>? availableCommitments,
    DailyCommitment? selectedCommitment,
    bool clearSelectedCommitment = false,
    int? currentStep,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? reachedChest,
  }) {
    return OnboardingState(
      availableGoals: availableGoals ?? this.availableGoals,
      selectedGoal:
          clearSelectedGoal ? null : (selectedGoal ?? this.selectedGoal),
      availableMasteryGoals: availableMasteryGoals ?? this.availableMasteryGoals,
      selectedMasteryGoal: clearSelectedMasteryGoal
          ? null
          : (selectedMasteryGoal ?? this.selectedMasteryGoal),
      availableExperienceLevels:
          availableExperienceLevels ?? this.availableExperienceLevels,
      selectedExperienceLevel: clearSelectedExperienceLevel
          ? null
          : (selectedExperienceLevel ?? this.selectedExperienceLevel),
      availablePersonalGoals:
          availablePersonalGoals ?? this.availablePersonalGoals,
      selectedPersonalGoal: clearSelectedPersonalGoal
          ? null
          : (selectedPersonalGoal ?? this.selectedPersonalGoal),
      availableCommitments: availableCommitments ?? this.availableCommitments,
      selectedCommitment: clearSelectedCommitment
          ? null
          : (selectedCommitment ?? this.selectedCommitment),
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      reachedChest: reachedChest ?? this.reachedChest,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingState &&
          other.selectedGoal == selectedGoal &&
          other.selectedMasteryGoal == selectedMasteryGoal &&
          other.selectedExperienceLevel == selectedExperienceLevel &&
          other.selectedPersonalGoal == selectedPersonalGoal &&
          other.selectedCommitment == selectedCommitment &&
          other.currentStep == currentStep &&
          other.isLoading == isLoading &&
          other.errorMessage == errorMessage &&
          other.reachedChest == reachedChest);

  @override
  int get hashCode => Object.hash(
        selectedGoal,
        selectedMasteryGoal,
        selectedExperienceLevel,
        selectedPersonalGoal,
        selectedCommitment,
        currentStep,
        isLoading,
        errorMessage,
        reachedChest,
      );
}


