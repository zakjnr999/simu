import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_controller.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_hero_section.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_practice_section.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_progress_path.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_social_proof.dart';

/// Screen 2 — Interactive Onboarding Welcome Page.
///
/// Visual composition matching the approved reference:
/// - Background: onboarding_world.png environmental scene
/// - Top Navigation: Simu branding + Skip button (Step 1) / Step indicator + XP Badge (Steps 2-5)
/// - Hero: Expressive headline + Ace mascot with speech bubble (Dynamic transitions)
/// - Progression Path: Interactive checkpoints 1-6 with sliding flag animation
/// - Practice Section: Category cards (Step 1) / Options swipers (Steps 2-5)
/// - Primary Action: Tactile 3D CTA button (dynamic text and flag icon)
/// - Footer: Social proof (all steps) + Step tracker label (Steps 2-5)
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Environmental Background Asset
          Image.asset(
            'assets/illustrations/onboarding/onboarding_world.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFF9F6EE),
            ),
          ),

          // 2. Safe Area Interactive Content (bottom: false to utilize the bottom screen edge space)
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Header (Logo + Skip/Progress Tracker)
                OnboardingHeader(
                  currentStep: state.currentStep,
                  onSkip: () => context.go(RouteNames.onboardingExperience),
                  onBack:
                      state.currentStep > 1 ? controller.previousStep : null,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bottomInset = MediaQuery.paddingOf(context).bottom;
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 4),
                              OnboardingHeroSection(
                                currentStep: state.currentStep,
                              ),
                              const SizedBox(height: 8),
                              OnboardingProgressPath(
                                currentStep: state.currentStep,
                                reachedChest: state.reachedChest,
                              ),
                              const SizedBox(height: 4),
                              OnboardingPracticeSection(
                                currentStep: state.currentStep,
                                availableGoals: state.availableGoals,
                                selectedGoal: state.selectedGoal,
                                onGoalSelected: controller.selectGoal,
                                availableMasteryGoals:
                                    state.availableMasteryGoals,
                                selectedMasteryGoal: state.selectedMasteryGoal,
                                onMasteryGoalSelected:
                                    controller.selectMasteryGoal,
                                availableExperienceLevels:
                                    state.availableExperienceLevels,
                                selectedExperienceLevel:
                                    state.selectedExperienceLevel,
                                onExperienceSelected:
                                    controller.selectExperience,
                                availablePersonalGoals:
                                    state.availablePersonalGoals,
                                selectedPersonalGoal:
                                    state.selectedPersonalGoal,
                                onPersonalGoalSelected:
                                    controller.selectPersonalGoal,
                                availableCommitments:
                                    state.availableCommitments,
                                selectedCommitment: state.selectedCommitment,
                                onCommitmentSelected:
                                    controller.selectCommitment,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: OnboardingPrimaryCta(
                                  isLoading: state.isLoading,
                                  text: state.currentStep == 1
                                      ? "Let's Begin the Journey!"
                                      : 'Continue My Journey',
                                  leftWidget: const SizedBox(width: 40),
                                  onPressed: () async {
                                    if (state.currentStep < 5) {
                                      controller.nextStep();
                                    } else if (!ref
                                        .read(
                                          curtainTransitionControllerProvider,
                                        )
                                        .isActive) {
                                      final completed = await ref
                                          .read(
                                            curtainTransitionControllerProvider
                                                .notifier,
                                          )
                                          .start(
                                            prepare: controller
                                                .completeOnboardingForTransition,
                                            navigate: () async {
                                              if (context.mounted) {
                                                context.go(
                                                  RouteNames.onboardingMascot,
                                                );
                                              }
                                            },
                                            reduceMotion: false,
                                          );
                                      assert(() {
                                        if (!completed) {
                                          debugPrint(
                                            'transition did not run '
                                            '(runner ready=${ref.read(curtainTransitionControllerProvider.notifier).hasRunner})',
                                          );
                                        }
                                        return true;
                                      }());
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Center(
                                child: OnboardingSocialProof(),
                              ),
                              SizedBox(height: 12 + bottomInset),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
