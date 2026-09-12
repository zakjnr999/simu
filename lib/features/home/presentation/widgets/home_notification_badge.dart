import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/surfaces/simu_tactile_pill.dart';

/// Notification chip — matches [OnboardingXpBadge] tactile surface styling.
class HomeNotificationBadge extends StatelessWidget {
  const HomeNotificationBadge({
    super.key,
    required this.unreadCount,
    this.onTap,
  });

  final int unreadCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SimuTactilePill(
      onTap: onTap,
      semanticsLabel: 'Notifications',
      semanticsButton: onTap != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              LucideIcons.bell,
              size: 18,
              color: Color(0xFF262453),
            ),
            if (unreadCount > 0)
              Positioned(
                top: -6,
                right: -8,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
