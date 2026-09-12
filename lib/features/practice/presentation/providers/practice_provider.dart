import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/practice/domain/entities/practice_category_definition.dart';
import 'package:simu/features/practice/domain/practice_catalog.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Computed state for a practice category enriched with user progression data.
class PracticeProgressSummary {
  const PracticeProgressSummary({
    required this.definition,
    required this.isPrimary,
    required this.completedCount,
    required this.totalCount,
    required this.progressRatio,
  });

  final PracticeCategoryDefinition definition;
  final bool isPrimary;
  final int completedCount;
  final int totalCount;
  final double progressRatio;
}

final practiceSummariesProvider =
    Provider<List<PracticeProgressSummary>>((ref) {
  final onboarding = ref.watch(onboardingControllerProvider);
  final progression = ref.watch(userProgressionProvider);
  final primaryCategory =
      onboarding.selectedGoal?.category ?? UserGoalCategory.interviews;

  final all = PracticeCatalog.getAll();

  return all.map((def) {
    final isPrimary = def.category == primaryCategory;
    final completedCount = def.challenges.where((c) {
      final scenarioId = c.scenarioId;
      return c.isCompleted ||
          (scenarioId != null &&
              progression.completedScenarios.contains(scenarioId));
    }).length;

    final totalCount = def.challenges.length;
    final progressRatio =
        totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;

    return PracticeProgressSummary(
      definition: def,
      isPrimary: isPrimary,
      completedCount: completedCount,
      totalCount: totalCount,
      progressRatio: progressRatio,
    );
  }).toList();
});

final practiceCategoryProvider = Provider.family<PracticeProgressSummary, UserGoalCategory>(
  (ref, category) {
    final summaries = ref.watch(practiceSummariesProvider);
    return summaries.firstWhere(
      (s) => s.definition.category == category,
      orElse: () => summaries.first,
    );
  },
);
