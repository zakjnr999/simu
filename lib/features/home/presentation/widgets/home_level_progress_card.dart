import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';

/// Level progress card on the home screen — flat white shell, splash-style bar.
class HomeLevelProgressCard extends StatelessWidget {
  const HomeLevelProgressCard({
    super.key,
    required this.level,
    required this.title,
    required this.currentXp,
    required this.targetXp,
    this.levelBadgeAsset = 'assets/illustrations/home/home_level_badge.png',
    this.rewardChestAsset =
        'assets/illustrations/home/home_level_reward_chest.png',
    this.onRewardTap,
  });

  final int level;
  final String title;
  final int currentXp;
  final int targetXp;
  final String levelBadgeAsset;
  final String rewardChestAsset;
  final VoidCallback? onRewardTap;

  static const double _cardRadius = 20;
  static const double _shieldWidth = 58;
  static const double _shieldHeight = 68;
  static const double _chestSize = 50;
  static const double _cardLeftInset = 24;
  static const double _cardVerticalInset = 2;

  @override
  Widget build(BuildContext context) {
    final progress =
        targetXp > 0 ? (currentXp / targetXp).clamp(0.0, 1.0) : 0.0;

    return Semantics(
      label: 'Level $level, $title, $currentXp of $targetXp experience points',
      child: SizedBox(
        height: _shieldHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              left: _cardLeftInset,
              right: 0,
              top: _cardVerticalInset,
              bottom: _cardVerticalInset,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_cardRadius),
                  border: Border.all(
                    color: const Color(0xFFEFE8DD),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(44, 10, 12, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.titleSmall.copyWith(
                                color: const Color(0xFF262554),
                                fontSize: 15,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SimuProgressBar(
                                    progress: progress,
                                    height: 14,
                                    isStriped: true,
                                    animateStripes: false,
                                    fillColor: const Color(0xFF7551FF),
                                    fillHighlightColor: const Color(0xFF8E6BFF),
                                    depthColor: const Color(0xFF4F27D4),
                                    backgroundColor: const Color(0xFFF7EFE5),
                                    grooveTopColor: const Color(0xFFDECBB6),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$currentXp / $targetXp XP',
                                  style: AppTypography.caption.copyWith(
                                    color: const Color(0xFF262554),
                                    fontSize: 11,
                                    height: 1.1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onRewardTap,
                        behavior: HitTestBehavior.opaque,
                        child: Image.asset(
                          rewardChestAsset,
                          width: _chestSize,
                          height: _chestSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                            width: _chestSize,
                            height: _chestSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                levelBadgeAsset,
                width: _shieldWidth,
                height: _shieldHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: _shieldWidth,
                  height: _shieldHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
