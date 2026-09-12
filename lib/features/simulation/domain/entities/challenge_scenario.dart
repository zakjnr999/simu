import 'package:simu/features/simulation/domain/entities/challenge_step.dart';

/// Category for challenge scenarios matching onboarding goals.
enum ChallengeCategory {
  interviews('Interviews', 'assets/illustrations/onboarding/icons/interview_icon.png'),
  communication('Communication', 'assets/illustrations/onboarding/icons/communication_icon.png'),
  negotiation('Negotiation', 'assets/illustrations/onboarding/icons/negotiation_icon.png'),
  technical('Technical', 'assets/illustrations/onboarding/icons/technical_icon.png');

  const ChallengeCategory(this.displayName, this.iconAsset);
  final String displayName;
  final String iconAsset;
}

/// Difficulty rating for a challenge.
enum ChallengeDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  const ChallengeDifficulty(this.label);
  final String label;
}

/// Domain model for an interactive simulation challenge.
class ChallengeScenario {
  const ChallengeScenario({
    required this.id,
    required this.category,
    required this.title,
    required this.situationSetup,
    required this.userObjective,
    required this.interviewerName,
    required this.interviewerRole,
    required this.interviewerCompany,
    required this.skillsPracticed,
    required this.difficulty,
    required this.durationMinutes,
    required this.xpReward,
    required this.aceGuidance,
    required this.openingPrompt,
    required this.maxTurns,
    this.steps = const [],
    this.turnSuggestions = const {},
  });

  final String id;
  final ChallengeCategory category;
  final String title;
  final String situationSetup;
  final String userObjective;
  final String interviewerName;
  final String interviewerRole;
  final String interviewerCompany;
  final List<String> skillsPracticed;
  final ChallengeDifficulty difficulty;
  final int durationMinutes;
  final int xpReward;
  final String aceGuidance;
  final String openingPrompt;
  final int maxTurns;
  final List<ChallengeStep> steps;
  final Map<int, List<String>> turnSuggestions;
}
