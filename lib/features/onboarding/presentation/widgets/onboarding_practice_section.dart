import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/onboarding/domain/entities/daily_commitment.dart';
import 'package:simu/features/onboarding/domain/entities/experience_level.dart';
import 'package:simu/features/onboarding/domain/entities/mastery_goal.dart';
import 'package:simu/features/onboarding/domain/entities/personal_goal.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/widgets/mastery_goal_card.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_spark_splay.dart';
import 'package:simu/features/onboarding/presentation/widgets/practice_category_card.dart';

/// Section showing the practice categories (Step 1) or the choices options (Steps 2-5)
/// rendered as a horizontal scroll list of cards (matching Step 1 design).
class OnboardingPracticeSection extends StatelessWidget {
  const OnboardingPracticeSection({
    super.key,
    required this.availableGoals,
    required this.selectedGoal,
    required this.onGoalSelected,
    this.currentStep = 1,
    this.availableMasteryGoals = const [],
    this.selectedMasteryGoal,
    this.onMasteryGoalSelected,
    this.availableExperienceLevels = const [],
    this.selectedExperienceLevel,
    this.onExperienceSelected,
    this.availablePersonalGoals = const [],
    this.selectedPersonalGoal,
    this.onPersonalGoalSelected,
    this.availableCommitments = const [],
    this.selectedCommitment,
    this.onCommitmentSelected,
  });

  final List<UserGoal> availableGoals;
  final UserGoal? selectedGoal;
  final ValueChanged<UserGoal> onGoalSelected;

  final int currentStep;

  // Step 2
  final List<MasteryGoal> availableMasteryGoals;
  final MasteryGoal? selectedMasteryGoal;
  final ValueChanged<MasteryGoal>? onMasteryGoalSelected;

  // Step 3
  final List<ExperienceLevel> availableExperienceLevels;
  final ExperienceLevel? selectedExperienceLevel;
  final ValueChanged<ExperienceLevel>? onExperienceSelected;

  // Step 4
  final List<PersonalGoal> availablePersonalGoals;
  final PersonalGoal? selectedPersonalGoal;
  final ValueChanged<PersonalGoal>? onPersonalGoalSelected;

  // Step 5
  final List<DailyCommitment> availableCommitments;
  final DailyCommitment? selectedCommitment;
  final ValueChanged<DailyCommitment>? onCommitmentSelected;

  static const double _sectionTitleHeight = 34;
  static const double _cardAreaHeight = 186;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title: fixed height so step changes never push content below.
        SizedBox(
          height: _sectionTitleHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const OnboardingSparkSplay(isLeft: true),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  currentStep == 1
                      ? 'What do you want to practice?'
                      : 'Swipe to explore your options',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.heading3.copyWith(
                    color: const Color(0xFF262453),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const OnboardingSparkSplay(isLeft: false),
            ],
          ),
        ),

        // Swappable card list in a fixed-height viewport.
        SizedBox(
          height: _cardAreaHeight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildChoiceList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceList() {
    if (currentStep == 1) {
      return _buildStep1Categories(key: const ValueKey('categories_step1'));
    }
    return _buildSteps2to5ChoiceList(key: ValueKey('categories_step_$currentStep'));
  }

  /// Step 1: Category cards scroll view
  Widget _buildStep1Categories({required Key key}) {
    return SingleChildScrollView(
      key: key,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: availableGoals.map((goal) {
          final isSelected = selectedGoal?.category == goal.category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: PracticeCategoryCard(
              goal: goal,
              isSelected: isSelected,
              onTap: () => onGoalSelected(goal),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Steps 2-5: Choice cards scroll view (identical horizontal list format)
  Widget _buildSteps2to5ChoiceList({required Key key}) {
    final List<Widget> cardWidgets = [];

    switch (currentStep) {
      case 2:
        for (final goal in availableMasteryGoals) {
          final isSelected = selectedMasteryGoal?.id == goal.id;
          cardWidgets.add(
            OnboardingChoiceCard(
              id: goal.id,
              title: goal.title,
              description: goal.description,
              xpBonus: goal.xpBonus,
              iconEmoji: goal.iconEmoji,
              iconAssetPath: goal.iconAssetPath,
              isSelected: isSelected,
              onTap: () {
                if (onMasteryGoalSelected != null) {
                  onMasteryGoalSelected!(goal);
                }
              },
            ),
          );
        }
        break;
      case 3:
        for (final lvl in availableExperienceLevels) {
          final isSelected = selectedExperienceLevel?.id == lvl.id;
          cardWidgets.add(
            OnboardingChoiceCard(
              id: lvl.id,
              title: lvl.title,
              description: lvl.description,
              xpBonus: lvl.xpBonus,
              iconEmoji: lvl.iconEmoji,
              iconAssetPath: lvl.iconAssetPath,
              isSelected: isSelected,
              onTap: () {
                if (onExperienceSelected != null) {
                  onExperienceSelected!(lvl);
                }
              },
            ),
          );
        }
        break;
      case 4:
        for (final goal in availablePersonalGoals) {
          final isSelected = selectedPersonalGoal?.id == goal.id;
          cardWidgets.add(
            OnboardingChoiceCard(
              id: goal.id,
              title: goal.title,
              description: goal.description,
              xpBonus: goal.xpBonus,
              iconEmoji: goal.iconEmoji,
              iconAssetPath: goal.iconAssetPath,
              isSelected: isSelected,
              onTap: () {
                if (onPersonalGoalSelected != null) {
                  onPersonalGoalSelected!(goal);
                }
              },
            ),
          );
        }
        break;
      case 5:
        for (final comm in availableCommitments) {
          final isSelected = selectedCommitment?.id == comm.id;
          cardWidgets.add(
            OnboardingChoiceCard(
              id: comm.id,
              title: comm.title,
              description: comm.description,
              xpBonus: comm.xpBonus,
              iconEmoji: comm.iconEmoji,
              iconAssetPath: comm.iconAssetPath,
              isSelected: isSelected,
              onTap: () {
                if (onCommitmentSelected != null) {
                  onCommitmentSelected!(comm);
                }
              },
            ),
          );
        }
        break;
    }

    return SingleChildScrollView(
      key: key,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cardWidgets.map((card) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: card,
          );
        }).toList(),
      ),
    );
  }
}
