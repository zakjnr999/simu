import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Domain entity representing a user's mastery goal selection (Step 2).
class MasteryGoal {
  const MasteryGoal({
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

  static const List<MasteryGoal> predefinedGoals = [
    MasteryGoal(
      id: 'dream_job',
      title: 'Land my dream job',
      description: 'Get interview-ready.\nStand out.',
      xpBonus: 120,
      iconEmoji: '💼',
      fallbackIcon: LucideIcons.target,
      iconAssetPath: 'assets/illustrations/onboarding/icons/mastery_interviews.png',
    ),
    MasteryGoal(
      id: 'confidence',
      title: 'Answer confidently',
      description: 'Speak clearly.\nAny interview.',
      xpBonus: 100,
      iconEmoji: '💬',
      fallbackIcon: LucideIcons.messageSquare,
      iconAssetPath: 'assets/illustrations/onboarding/icons/mastery_confidence.png',
    ),
    MasteryGoal(
      id: 'think_feet',
      title: 'Think on my feet',
      description: 'Handle surprises\nlike a pro.',
      xpBonus: 110,
      iconEmoji: '🧠',
      fallbackIcon: LucideIcons.brain,
      iconAssetPath: 'assets/illustrations/onboarding/icons/mastery_negotiation.png',
    ),
    MasteryGoal(
      id: 'tough_questions',
      title: 'Tough questions',
      description: 'Stay calm\nunder pressure.',
      xpBonus: 120,
      iconEmoji: '🛡️',
      fallbackIcon: LucideIcons.shield,
      iconAssetPath: 'assets/illustrations/onboarding/icons/mastery_technical.png',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasteryGoal && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
