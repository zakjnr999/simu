import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_shadows.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/journey/domain/entities/journey_milestone.dart';

/// Single milestone on the journey preview path: badge, island art, info card.
class JourneyMilestoneTile extends StatelessWidget {
  const JourneyMilestoneTile({
    super.key,
    required this.index,
    required this.milestone,
    this.verticalOffset = 0,
    this.onTap,
  });

  final int index;
  final JourneyMilestone milestone;
  final double verticalOffset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = milestone.isLocked;
    final isActive = milestone.isActive;

    final content = Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: verticalOffset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MilestoneIsland(
              index: index,
              iconAssetPath: milestone.iconAssetPath,
              isActive: isActive,
              isLocked: isLocked,
            ),
            const SizedBox(height: 6),
            _MilestoneInfoCard(
              milestone: milestone,
              isActive: isActive,
            ),
          ],
        ),
      ),
    );

    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      label: '${milestone.title}, ${milestone.rewardLabel}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: isActive
            ? DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFE082).withValues(alpha: 0.22),
                      blurRadius: 28,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}

class _MilestoneIsland extends StatelessWidget {
  const _MilestoneIsland({
    required this.index,
    required this.iconAssetPath,
    required this.isActive,
    required this.isLocked,
  });

  final int index;
  final String iconAssetPath;
  final bool isActive;
  final bool isLocked;

  static const double _islandWidth = 58;
  static const double _stackHeight = 80;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _islandWidth,
      height: _stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Number badge floats above the island — not on the artwork.
          Positioned(
            top: 0,
            left: 8,
            child: _MilestoneNumberBadge(number: index),
          ),
          if (isActive)
            Positioned(
              left: 4,
              right: 4,
              bottom: 2,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFE082).withValues(alpha: 0.38),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 3,
            right: 3,
            bottom: 0,
            child: Image.asset(
              iconAssetPath,
              width: 54,
              height: 60,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(width: 54, height: 60),
            ),
          ),
          if (isLocked)
            Positioned(
              right: 0,
              bottom: 12,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE0D6C8),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.lock,
                  size: 9,
                  color: Color(0xFF8A8FA8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MilestoneNumberBadge extends StatelessWidget {
  const _MilestoneNumberBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF7551FF),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7551FF).withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$number',
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _MilestoneInfoCard extends StatelessWidget {
  const _MilestoneInfoCard({
    required this.milestone,
    required this.isActive,
  });

  final JourneyMilestone milestone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(5, 6, 5, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive
              ? const Color(0xFFFFE082)
              : const Color(0xFFEFE8DD),
          width: isActive ? 1.5 : 1.2,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            milestone.title,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF262554),
              fontSize: 9,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF7551FF).withValues(alpha: 0.18),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                milestone.rewardLabel,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF7551FF),
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
