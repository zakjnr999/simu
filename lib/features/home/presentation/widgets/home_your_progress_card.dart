import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/journey/domain/journey_milestone_assets.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';

/// Journey progress summary card — composed from existing Simu widgets.
class HomeYourProgressCard extends StatelessWidget {
  const HomeYourProgressCard({
    super.key,
    required this.practiceLabel,
    required this.completedMilestones,
    required this.totalMilestones,
    required this.totalXp,
    this.dayStreak = 3,
    this.badgesEarned = 2,
    this.streakIconAsset = 'assets/illustrations/home/home_streak_icon.png',
    this.achievementIconAsset =
        'assets/illustrations/home/home_achievement_icon.png',
    this.milestoneIconAsset = JourneyMilestoneAssets.milestone01Flag,
    this.starIconAsset = 'assets/icons/star_icon.png',
    this.onViewJourneyTap,
  });

  final String practiceLabel;
  final int completedMilestones;
  final int totalMilestones;
  final int totalXp;
  final int dayStreak;
  final int badgesEarned;
  final String streakIconAsset;
  final String achievementIconAsset;
  final String milestoneIconAsset;
  final String starIconAsset;
  final VoidCallback? onViewJourneyTap;

  @override
  Widget build(BuildContext context) {
    final progress = totalMilestones > 0
        ? (completedMilestones / totalMilestones).clamp(0.0, 1.0)
        : 0.0;
    final progressPercent = (progress * 100).round();

    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.chartColumn,
                size: 16,
                color: Color(0xFF7551FF),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'YOUR PROGRESS',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: const Color(0xFF7551FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onViewJourneyTap,
                behavior: HitTestBehavior.opaque,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Journey',
                      style: TextStyle(
                        color: Color(0xFF7551FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito Sans',
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: Color(0xFF7551FF),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      practiceLabel,
                      style: AppTypography.titleSmall.copyWith(
                        color: const Color(0xFF262554),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedMilestones of $totalMilestones Milestones Completed',
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xFF5A627D),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SimuProgressBar(
                            progress: progress,
                            height: 12,
                            isStriped: true,
                            animateStripes: false,
                            fillColor: const Color(0xFF7551FF),
                            fillHighlightColor: const Color(0xFF8E6BFF),
                            depthColor: const Color(0xFF4F27D4),
                            backgroundColor: const Color(0xFFF7EFE5),
                            grooveTopColor: const Color(0xFFDECBB6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$progressPercent%',
                          style: AppTypography.caption.copyWith(
                            color: const Color(0xFF7551FF),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEFE8DD),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _HomeProgressStat(
                    value: '$dayStreak',
                    label: 'Day Streak',
                    icon: Image.asset(
                      streakIconAsset,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(width: 28, height: 28),
                    ),
                  ),
                ),
                const _HomeProgressStatDivider(),
                Expanded(
                  child: _HomeProgressStat(
                    value: '$totalXp',
                    label: 'Total XP',
                    icon: Image.asset(
                      starIconAsset,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Text('⭐', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                const _HomeProgressStatDivider(),
                Expanded(
                  child: _HomeProgressStat(
                    value: '$badgesEarned',
                    label: 'Badges Earned',
                    icon: Image.asset(
                      achievementIconAsset,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(width: 28, height: 28),
                    ),
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

class _HomeProgressStatDivider extends StatelessWidget {
  const _HomeProgressStatDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: Color(0xFFEFE8DD),
      ),
    );
  }
}

class _HomeProgressStat extends StatelessWidget {
  const _HomeProgressStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall.copyWith(
                  color: const Color(0xFF262554),
                  fontSize: 16,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF5A627D),
                  fontSize: 9,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
