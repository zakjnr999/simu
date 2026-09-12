import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_shadows.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Social proof pill widget showing 3 overlapping learner avatars and active user count.
class OnboardingSocialProof extends StatelessWidget {
  const OnboardingSocialProof({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.roundedPill,
        border: Border.all(
          color: const Color(0xFFF1E9DE),
          width: 1.5,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 3 Overlapping Avatars
          SizedBox(
            width: 60,
            height: 28,
            child: Stack(
              children: [
                _buildAvatar(
                    'assets/illustrations/onboarding/avatars/learner_1.png', 0),
                _buildAvatar(
                    'assets/illustrations/onboarding/avatars/learner_2.png',
                    16),
                _buildAvatar(
                    'assets/illustrations/onboarding/avatars/learner_3.png',
                    32),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Text + Status dot
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '2.4K+ learners',
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF262453),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'already leveling up',
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFF5A627D),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String assetPath, double leftOffset) {
    return Positioned(
      left: leftOffset,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            assetPath,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
                LucideIcons.user,
                size: 16,
                color: Color(0xFF7551FF)),
          ),
        ),
      ),
    );
  }
}
