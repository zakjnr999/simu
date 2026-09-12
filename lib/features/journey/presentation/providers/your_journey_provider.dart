import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/core/services/user/user_display_name_provider.dart';
import 'package:simu/features/journey/domain/entities/journey_milestone.dart';
import 'package:simu/features/journey/domain/journey_configs.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';

/// One row in the journey summary card.
class JourneySummaryItemModel {
  const JourneySummaryItemModel({
    required this.label,
    required this.value,
    required this.iconAssetPath,
  });

  final String label;
  final String value;
  final String? iconAssetPath;
}

/// View model for the Your Simu Journey screen.
class YourJourneyUiModel {
  const YourJourneyUiModel({
    required this.displayName,
    required this.totalXp,
    required this.summaryItems,
    required this.previewMilestones,
    required this.allMilestones,
    required this.practiceCategory,
  });

  final String displayName;
  final int totalXp;
  final List<JourneySummaryItemModel> summaryItems;
  final List<JourneyMilestone> previewMilestones;
  final List<JourneyMilestone> allMilestones;
  final UserGoalCategory practiceCategory;
}

final yourJourneyUiModelProvider = Provider<YourJourneyUiModel?>((ref) {
  final onboarding = ref.watch(onboardingControllerProvider);
  final displayNameAsync = ref.watch(userDisplayNameProvider);

  final goal = onboarding.selectedGoal;
  final mastery = onboarding.selectedMasteryGoal;
  final experience = onboarding.selectedExperienceLevel;
  final commitment = onboarding.selectedCommitment;

  if (goal == null ||
      mastery == null ||
      experience == null ||
      commitment == null) {
    return null;
  }

  final displayName = displayNameAsync.maybeWhen(
    data: (name) => name,
    orElse: () => 'Friend',
  );

  final journey = JourneyConfigs.forCategory(goal.category);

  return YourJourneyUiModel(
    displayName: displayName,
    totalXp: onboarding.totalOnboardingXp,
    practiceCategory: goal.category,
    previewMilestones: journey.previewMilestones(),
    allMilestones: journey.milestones,
    summaryItems: [
      JourneySummaryItemModel(
        label: 'You want to practice',
        value: '${goal.title} Practice',
        iconAssetPath: goal.iconAssetPath,
      ),
      JourneySummaryItemModel(
        label: 'You want to master',
        value: mastery.title,
        iconAssetPath: mastery.iconAssetPath,
      ),
      JourneySummaryItemModel(
        label: 'Your experience level',
        value: experience.title,
        iconAssetPath: experience.iconAssetPath,
      ),
      JourneySummaryItemModel(
        label: 'Your daily commitment',
        value: '${commitment.title} a day',
        iconAssetPath: commitment.iconAssetPath,
      ),
    ],
  );
});
