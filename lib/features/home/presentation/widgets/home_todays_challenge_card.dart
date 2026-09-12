import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';

/// Today's challenge card — composed from existing Simu onboarding widgets.
class HomeTodaysChallengeCard extends StatelessWidget {
  const HomeTodaysChallengeCard({
    super.key,
    required this.title,
    required this.categoryLabel,
    required this.description,
    required this.xpReward,
    required this.illustrationAsset,
    this.durationLabel = '10–12 min',
    this.starIconAsset = 'assets/icons/star_icon.png',
    this.onStartChallenge,
  });

  final String title;
  final String categoryLabel;
  final String description;
  final int xpReward;
  final String illustrationAsset;
  final String durationLabel;
  final String starIconAsset;
  final VoidCallback? onStartChallenge;

  @override
  Widget build(BuildContext context) {
    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(
                starIconAsset,
                width: 14,
                height: 14,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('⭐', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 5),
              Text(
                "TODAY'S CHALLENGE",
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF7551FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.heading2.copyWith(
                        color: const Color(0xFF262554),
                        fontSize: 19,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      categoryLabel,
                      style: AppTypography.titleSmall.copyWith(
                        color: const Color(0xFF7551FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF5A627D),
                        fontSize: 11,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        SimuBadge(
                          text: '+$xpReward XP',
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFF262554),
                          borderColor: const Color(0xFFEFE8DD),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          icon: Image.asset(
                            starIconAsset,
                            width: 12,
                            height: 12,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text('⭐', style: TextStyle(fontSize: 10)),
                          ),
                        ),
                        SimuBadge(
                          text: durationLabel,
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFF262554),
                          borderColor: const Color(0xFFEFE8DD),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          icon: const Icon(
                            LucideIcons.clock,
                            size: 12,
                            color: Color(0xFF7551FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(
                illustrationAsset,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(width: 76, height: 76),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OnboardingPrimaryCta(
            text: 'Start Challenge',
            leftWidget: const SizedBox(width: 36),
            onPressed: onStartChallenge ?? () {},
          ),
        ],
      ),
    );
  }
}
