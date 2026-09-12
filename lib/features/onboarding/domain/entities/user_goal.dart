/// Domain entity representing a user's practice goal.
///
/// Categories strictly adhere to: Interviews, Communication, Negotiation, Technical.
enum UserGoalCategory {
  interviews,
  communication,
  negotiation,
  technical,
}

class UserGoal {
  const UserGoal({
    required this.category,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.xpBonus,
    this.iconAssetPath,
  });

  final UserGoalCategory category;
  final String title;
  final String description;
  final String iconEmoji;
  final int xpBonus;
  final String? iconAssetPath;

  static const List<UserGoal> predefinedGoals = [
    UserGoal(
      category: UserGoalCategory.interviews,
      title: 'Interviews',
      description: 'Crush your next\ninterview.',
      iconEmoji: '💼',
      xpBonus: 120,
      iconAssetPath:
          'assets/illustrations/onboarding/icons/interviews_icon.png',
    ),
    UserGoal(
      category: UserGoalCategory.communication,
      title: 'Communication',
      description: 'Speak clearly.\nConnect better.',
      iconEmoji: '💬',
      xpBonus: 100,
      iconAssetPath:
          'assets/illustrations/onboarding/icons/communication_icon.png',
    ),
    UserGoal(
      category: UserGoalCategory.negotiation,
      title: 'Negotiation',
      description: 'Get better\noutcomes.',
      iconEmoji: '🤝',
      xpBonus: 120,
      iconAssetPath:
          'assets/illustrations/onboarding/icons/negotiation_icon.png',
    ),
    UserGoal(
      category: UserGoalCategory.technical,
      title: 'Technical',
      description: 'Solve problems.\nThink deeper.',
      iconEmoji: '💻',
      xpBonus: 110,
      iconAssetPath: 'assets/illustrations/onboarding/icons/technical_icon.png',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGoal && other.category == category);

  @override
  int get hashCode => category.hashCode;
}
