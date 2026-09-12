import 'package:flutter/material.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_xp_badge.dart';

/// Top bar with XP indicator only (matches Meet Ace header).
class JourneyHeaderBar extends StatelessWidget {
  const JourneyHeaderBar({
    super.key,
    required this.totalXp,
  });

  final int totalXp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: OnboardingXpBadge(totalXp: totalXp),
      ),
    );
  }
}
