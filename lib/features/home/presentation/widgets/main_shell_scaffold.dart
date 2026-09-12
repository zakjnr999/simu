import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/features/home/domain/simu_nav_destination.dart';
import 'package:simu/features/home/presentation/pages/home_page.dart';
import 'package:simu/features/home/presentation/widgets/simu_bottom_nav_bar.dart';

/// Persistent shell that keeps the bottom nav alive across main tab switches.
class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({
    super.key,
    required this.navigationShell,
    this.onCenterActionTap,
  });

  final StatefulNavigationShell navigationShell;
  final VoidCallback? onCenterActionTap;

  static const double bottomNavReserve = 104;

  SimuNavDestination get _current =>
      SimuNavDestination.values[navigationShell.currentIndex];

  @override
  Widget build(BuildContext context) {
    final isHome = _current == SimuNavDestination.home;

    return Scaffold(
      backgroundColor: isHome ? Colors.transparent : AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isHome)
            Positioned.fill(
              child: Image.asset(
                HomePage.backgroundAsset,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: bottomNavReserve),
              child: navigationShell,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SimuBottomNavBar(
              current: _current,
              onCenterActionTap: onCenterActionTap,
              onDestinationSelected: (destination) {
                final index = destination.index;
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
