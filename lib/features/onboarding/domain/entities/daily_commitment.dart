import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Domain entity representing a user's daily commitment selection (Step 5).
class DailyCommitment {
  const DailyCommitment({
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

  static const List<DailyCommitment> predefinedCommitments = [
    DailyCommitment(
      id: '5_10_min',
      title: '5–10 mins',
      description: 'Quick daily\nboost.',
      xpBonus: 80,
      iconEmoji: '⏰',
      fallbackIcon: LucideIcons.alarmClock,
      iconAssetPath: 'assets/illustrations/onboarding/icons/commitment_5_10.png',
    ),
    DailyCommitment(
      id: '10_20_min',
      title: '10–20 mins',
      description: 'Focused session.\nBuild momentum.',
      xpBonus: 100,
      iconEmoji: '📅',
      fallbackIcon: LucideIcons.calendarRange,
      iconAssetPath: 'assets/illustrations/onboarding/icons/commitment_10_20.png',
    ),
    DailyCommitment(
      id: '20_30_min',
      title: '20–30 mins',
      description: 'Ideal practice\ntime.',
      xpBonus: 120,
      iconEmoji: '⏳',
      fallbackIcon: LucideIcons.hourglass,
      iconAssetPath: 'assets/illustrations/onboarding/icons/commitment_20_30.png',
    ),
    DailyCommitment(
      id: '30_45_min',
      title: '30–45 mins',
      description: 'Go deeper.\nLevel up faster.',
      xpBonus: 140,
      iconEmoji: '🕒',
      fallbackIcon: LucideIcons.clock,
      iconAssetPath: 'assets/illustrations/onboarding/icons/commitment_30_45.png',
    ),
    DailyCommitment(
      id: '45_plus_min',
      title: '45+ mins',
      description: "All in!\nLet's master this.",
      xpBonus: 160,
      iconEmoji: '🏆',
      fallbackIcon: LucideIcons.trophy,
      iconAssetPath: 'assets/illustrations/onboarding/icons/commitment_45_plus.png',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCommitment && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
