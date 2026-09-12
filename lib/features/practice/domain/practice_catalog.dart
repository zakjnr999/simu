import 'package:flutter/material.dart';
import 'package:simu/features/journey/domain/journey_configs.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/practice/domain/entities/practice_category_definition.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';

/// Centralized data catalog for all practice categories in Simu.
class PracticeCatalog {
  PracticeCatalog._();

  static List<PracticeCategoryDefinition> getAll() {
    return UserGoalCategory.values.map(getByCategory).toList();
  }

  static PracticeCategoryDefinition getByCategory(UserGoalCategory category) {
    final journey = JourneyConfigs.forCategory(category);
    final allChallenges = journey.milestones.expand((m) => m.challenges).toList();

    switch (category) {
      case UserGoalCategory.interviews:
        return PracticeCategoryDefinition(
          category: UserGoalCategory.interviews,
          title: 'Interview Mastery',
          tagline: 'Crush behavioral & executive rounds with composure.',
          description:
              'Step into high-stakes behavioral and technical interview simulations. Master first impressions, the Present-Past-Future narrative arc, and handling pressure questions.',
          skillsPracticed: const [
            'Present-Past-Future',
            'STAR Framework',
            'Executive Presence',
            'Story Hook',
            'Composure Under Stress',
          ],
          difficulty: ChallengeDifficulty.beginner,
          estimatedMinutesPerSession: 8,
          iconEmoji: '💼',
          iconAsset: 'assets/illustrations/onboarding/icons/interview_icon.png',
          accentColor: const Color(0xFF6C5CE7),
          accentBgColor: const Color(0xFFF1EFFF),
          challenges: allChallenges,
          totalMilestones: journey.milestones.length,
        );

      case UserGoalCategory.communication:
        return PracticeCategoryDefinition(
          category: UserGoalCategory.communication,
          title: 'Clear Communication',
          tagline: 'Express complex ideas with brevity and executive empathy.',
          description:
              'Practice translating technical jargon into plain business impact. Learn to give constructive upward feedback, handle objections, and run executive updates.',
          skillsPracticed: const [
            'Executive Empathy',
            'Brevity & Punch',
            'Active Listening',
            'Non-defensiveness',
            'Stakeholder Alignment',
          ],
          difficulty: ChallengeDifficulty.intermediate,
          estimatedMinutesPerSession: 10,
          iconEmoji: '💬',
          iconAsset: 'assets/illustrations/onboarding/icons/communication_icon.png',
          accentColor: const Color(0xFF00B894),
          accentBgColor: const Color(0xFFE8F8F5),
          challenges: allChallenges,
          totalMilestones: journey.milestones.length,
        );

      case UserGoalCategory.negotiation:
        return PracticeCategoryDefinition(
          category: UserGoalCategory.negotiation,
          title: 'Strategic Negotiation',
          tagline: 'Anchor your value and secure top-of-market outcomes.',
          description:
              'Simulate compensation and project scope negotiations with recruiters and executives. Master value anchoring, tactful pushback, and multi-variable trade-offs.',
          skillsPracticed: const [
            'Value Anchoring',
            'Tactful Pushback',
            'Leverage Identification',
            'Emotional Composure',
            'Package Optimization',
          ],
          difficulty: ChallengeDifficulty.intermediate,
          estimatedMinutesPerSession: 10,
          iconEmoji: '🤝',
          iconAsset: 'assets/illustrations/onboarding/icons/negotiation_icon.png',
          accentColor: const Color(0xFFFF9F43),
          accentBgColor: const Color(0xFFFFF4E8),
          challenges: allChallenges,
          totalMilestones: journey.milestones.length,
        );

      case UserGoalCategory.technical:
        return PracticeCategoryDefinition(
          category: UserGoalCategory.technical,
          title: 'Technical Architecture',
          tagline: 'Deconstruct systems and defend architectural trade-offs.',
          description:
              'Engage in real-time system design reviews with principal architects. Extract ambiguous requirements, partition data pipelines, and defend high-scale trade-offs.',
          skillsPracticed: const [
            'Requirement Extraction',
            'System Decomposition',
            'SLA & Scale Scoping',
            'Trade-Off Defense',
            'Bottleneck Diagnosis',
          ],
          difficulty: ChallengeDifficulty.advanced,
          estimatedMinutesPerSession: 12,
          iconEmoji: '💻',
          iconAsset: 'assets/illustrations/onboarding/icons/technical_icon.png',
          accentColor: const Color(0xFF0984E3),
          accentBgColor: const Color(0xFFEBF5FB),
          challenges: allChallenges,
          totalMilestones: journey.milestones.length,
        );
    }
  }
}
