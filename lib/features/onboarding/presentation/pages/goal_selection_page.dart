import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_spacing.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/layout/simu_page_header.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/widgets/goal_card.dart';

/// Screen 3 — Goal Selection Page.
///
/// Allows user to select from the 4 approved practice categories:
/// - Interviews
/// - Communication
/// - Negotiation
/// - Technical
class GoalSelectionPage extends ConsumerWidget {
  const GoalSelectionPage({super.key});

  String _dialogueForCategory(UserGoalCategory? category) {
    return switch (category) {
      UserGoalCategory.interviews =>
        'Interviews are my specialty! We will get you totally job-ready! 💼',
      UserGoalCategory.communication =>
        'Clear communication builds immense influence. Let us master it! 💬',
      UserGoalCategory.negotiation =>
        'Negotiation is a superpower! Let us win your next outcome! 🤝',
      UserGoalCategory.technical =>
        'Technical depth + crisp articulation = unstoppable! ⚡',
      null =>
        'What skill would you like to master first? Tap a goal to get started! 🎯',
    };
  }

  MascotState _mascotStateForCategory(UserGoalCategory? category) {
    return switch (category) {
      UserGoalCategory.interviews => MascotState.celebrating,
      UserGoalCategory.communication => MascotState.speaking,
      UserGoalCategory.negotiation => MascotState.happy,
      UserGoalCategory.technical => MascotState.thinking,
      null => MascotState.encouraging,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    final currentDialogue = _dialogueForCategory(state.selectedGoal?.category);
    final currentMascotState =
        _mascotStateForCategory(state.selectedGoal?.category);

    return SimuScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header with Step 1 of 4 Progress
            SimuPageHeader(
              title: 'What is your primary goal?',
              subtitle:
                  'We will tailor your practice scenarios to match what you care about most.',
              currentStep: 1,
              totalSteps: 4,
              onBack: () => context.pop(),
            ),
            AppSpacing.gapV16,

            // Interactive Mascot Feedback Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SimuMascotGuidanceBar(
                message: currentDialogue,
                mascotState: currentMascotState,
                mascotSize: 72,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
            AppSpacing.gapV24,

            // 4 Approved Goal Selection Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: state.availableGoals.map((goal) {
                  final isSelected =
                      state.selectedGoal?.category == goal.category;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GoalCard(
                      goal: goal,
                      isSelected: isSelected,
                      onTap: () => controller.selectGoal(goal),
                    ),
                  );
                }).toList(),
              ),
            ),
            AppSpacing.gapV24,
          ],
        ),
      ),
      bottomAction: SimuPrimaryAction(
        label: 'Continue',
        isEnabled: state.hasSelection,
        isLoading: state.isLoading,
        icon: const Icon(
          LucideIcons.arrowRight,
          color: AppColors.textOnPrimary,
          size: 20,
        ),
        onPressed: () async {
          final success = await controller.saveGoalAndContinue();
          if (success && context.mounted) {
            context.go(RouteNames.onboardingExperience);
          }
        },
      ),
    );
  }
}
