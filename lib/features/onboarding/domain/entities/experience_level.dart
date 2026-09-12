import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Domain entity representing a user's experience level selection (Step 3).
class ExperienceLevel {
  const ExperienceLevel({
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

  static const List<ExperienceLevel> predefinedLevels = [
    ExperienceLevel(
      id: 'just_starting',
      title: 'Just Starting',
      description: "I'm completely\nnew to this.",
      xpBonus: 80,
      iconEmoji: '🌱',
      fallbackIcon: LucideIcons.leaf,
      iconAssetPath: 'assets/illustrations/onboarding/icons/experience_starting.png',
    ),
    ExperienceLevel(
      id: 'finding_feet',
      title: 'Finding My Feet',
      description: 'Know the basics.\nNeed practice.',
      xpBonus: 100,
      iconEmoji: '🌿',
      fallbackIcon: LucideIcons.leaf,
      iconAssetPath: 'assets/illustrations/onboarding/icons/experience_finding.png',
    ),
    ExperienceLevel(
      id: 'getting_confident',
      title: 'Getting Confident',
      description: 'I can do it.\nWant to improve.',
      xpBonus: 120,
      iconEmoji: '🌳',
      fallbackIcon: LucideIcons.treePine,
      iconAssetPath: 'assets/illustrations/onboarding/icons/experience_confident.png',
    ),
    ExperienceLevel(
      id: 'already_strong',
      title: 'Already Strong',
      description: 'Sharpen skills\nunder pressure.',
      xpBonus: 140,
      iconEmoji: '🏆',
      fallbackIcon: LucideIcons.trophy,
      iconAssetPath: 'assets/illustrations/onboarding/icons/experience_strong.png',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExperienceLevel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
