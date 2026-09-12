import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Domain entity representing a user's personal/main goal selection (Step 4).
class PersonalGoal {
  const PersonalGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.xpBonus,
    required this.iconEmoji,
    required this.fallbackIcon,
    this.iconAssetPath,
  });

  final String id;
  final String title;
  final String description;
  final int xpBonus;
  final String iconEmoji;
  final IconData fallbackIcon;
  final String? iconAssetPath;

  static const List<PersonalGoal> predefinedGoals = [
    PersonalGoal(
      id: 'dream_job',
      title: 'Dream Job',
      description: 'Get hired for a\nrole I love.',
      xpBonus: 120,
      iconEmoji: '🎯',
      fallbackIcon: LucideIcons.target,
      iconAssetPath: 'assets/illustrations/onboarding/icons/goal_dream_job.png',
    ),
    PersonalGoal(
      id: 'communication',
      title: 'Communication',
      description: 'Express myself\nclearly.',
      xpBonus: 100,
      iconEmoji: '💬',
      fallbackIcon: LucideIcons.messageSquare,
      iconAssetPath: 'assets/illustrations/onboarding/icons/goal_communication.png',
    ),
    PersonalGoal(
      id: 'grow_career',
      title: 'Grow Career',
      description: 'Level up skills.\nAdvance faster.',
      xpBonus: 120,
      iconEmoji: '🚀',
      fallbackIcon: LucideIcons.rocket,
      iconAssetPath: 'assets/illustrations/onboarding/icons/goal_grow_career.png',
    ),
    PersonalGoal(
      id: 'be_best',
      title: 'Be the Best',
      description: 'Challenge myself\nand stand out.',
      xpBonus: 110,
      iconEmoji: '🏆',
      fallbackIcon: LucideIcons.trophy,
      iconAssetPath: 'assets/illustrations/onboarding/icons/goal_be_best.png',
    ),
    PersonalGoal(
      id: 'boost_confidence',
      title: 'Confidence',
      description: 'Overcome doubts.\nBelieve in you.',
      xpBonus: 100,
      iconEmoji: '❤️',
      fallbackIcon: LucideIcons.heart,
      iconAssetPath: 'assets/illustrations/onboarding/icons/goal_boost_confidence.png',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalGoal && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
