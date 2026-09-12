import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/features/home/presentation/widgets/home_notification_badge.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_xp_badge.dart';

/// Top bar with notification + XP — aligned like Meet Ace header.
class HomeHeaderBar extends StatelessWidget {
  const HomeHeaderBar({
    super.key,
    required this.totalXp,
    this.unreadNotificationCount = 0,
    this.onNotificationTap,
  });

  final int totalXp;
  final int unreadNotificationCount;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OnboardingXpBadge(
              totalXp: totalXp,
              onTap: () => context.push(RouteNames.progress),
            ),
            const SizedBox(width: 8),
            HomeNotificationBadge(
              unreadCount: unreadNotificationCount,
              onTap: onNotificationTap,
            ),
          ],
        ),
      ),
    );
  }
}
