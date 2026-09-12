import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_speech_bubble.dart';

/// Small Ace avatar with a closing motivational message.
class JourneyAceFooter extends StatelessWidget {
  const JourneyAceFooter({super.key});

  static const String aceHeadAsset =
      'assets/illustrations/onboarding/meet_ace/ace_head.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            aceHeadAsset,
            width: 44,
            height: 44,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const CircleAvatar(radius: 22, child: Text('🐶')),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OnboardingSpeechBubble(
              tail: OnboardingSpeechBubbleTail.leftCenter,
              showShadow: false,
              child: Text(
                "I've prepared the perfect first challenge to kick off your journey! 🚀",
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF262554),
                  fontSize: 11,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
