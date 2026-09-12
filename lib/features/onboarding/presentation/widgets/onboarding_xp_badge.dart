import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/surfaces/simu_tactile_pill.dart';

/// XP pill used across onboarding and journey screens.
class OnboardingXpBadge extends StatelessWidget {
  const OnboardingXpBadge({
    super.key,
    required this.totalXp,
    this.starIconAsset = 'assets/icons/star_icon.png',
    this.onTap,
  });

  final int totalXp;
  final String starIconAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SimuTactilePill(
      onTap: onTap,
      semanticsLabel: '$totalXp experience points',
      semanticsButton: onTap != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              starIconAsset,
              width: 18,
              height: 18,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Text('⭐', style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 6),
            Text(
              '$totalXp XP',
              style: AppTypography.titleSmall.copyWith(
                color: const Color(0xFF262453),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
