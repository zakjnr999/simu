import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/home/domain/simu_nav_destination.dart';
import 'package:simu/features/home/presentation/widgets/nav_bar_notch_shape.dart';

/// Floating pill bottom navigation with center paw action.
class SimuBottomNavBar extends StatelessWidget {
  const SimuBottomNavBar({
    super.key,
    required this.current,
    required this.onDestinationSelected,
    this.onCenterActionTap,
  });

  static const String centerPawAsset =
      'assets/illustrations/home/nav_center_paw_button.png';

  static const Color _activeColor = Color(0xFF7551FF);
  static const Color _inactiveColor = Color(0xFF8A94A8);

  static const double _pawSize = 64;
  static const double _centerGap = 72;
  static const double _navBarHeight = 68;
  static const double _navBarCornerRadius = 24;
  static const double _pawRadius = _pawSize / 2;
  static const double _notchRadius = _pawRadius + 2;
  static const double _notchGuestCenterFromTop = 24;
  static const double _notchShoulderFillet = 6;
  static const double _pawTopOffset =
      barHeight - _navBarHeight + _notchGuestCenterFromTop - _pawRadius + 2;
  static const double _indicatorWidth = 26;
  static const double _indicatorHeight = 3;

  final SimuNavDestination current;
  final ValueChanged<SimuNavDestination> onDestinationSelected;
  final VoidCallback? onCenterActionTap;

  static const double barHeight = 96;

  /// Bottom offset — sits slightly into the safe area for a more anchored feel.
  static double bottomPaddingFor(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    if (bottomInset > 0) {
      return (bottomInset - 8).clamp(8.0, bottomInset);
    }
    return 12;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottomPaddingFor(context)),
      child: SizedBox(
        height: barHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _NavBarSurface(
                current: current,
                onDestinationSelected: onDestinationSelected,
              ),
            ),
            Positioned(
              top: _pawTopOffset,
              child: _CenterPawButton(onTap: onCenterActionTap),
            ),
          ],
        ),
      ),
    );
  }

  static double _indicatorCenterX(
      double barWidth, SimuNavDestination destination) {
    final slotWidth = (barWidth - _centerGap) / 4;
    final index = destination.index;

    if (index <= 1) {
      return slotWidth * index + slotWidth / 2;
    }

    return _centerGap + slotWidth * index + slotWidth / 2;
  }
}

class _NavBarSurface extends StatelessWidget {
  const _NavBarSurface({
    required this.current,
    required this.onDestinationSelected,
  });

  final SimuNavDestination current;
  final ValueChanged<SimuNavDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SimuBottomNavBar._navBarHeight,
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: NavBarNotchShape(
          cornerRadius: SimuBottomNavBar._navBarCornerRadius,
          notchRadius: SimuBottomNavBar._notchRadius,
          guestCenterFromTop: SimuBottomNavBar._notchGuestCenterFromTop,
          shoulderFillet: SimuBottomNavBar._notchShoulderFillet,
          side: BorderSide(
            color: Color(0xFFEFE8F5),
            width: 1.2,
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x1A1E1B4B),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final indicatorLeft = SimuBottomNavBar._indicatorCenterX(
                constraints.maxWidth,
                current,
              ) -
              (SimuBottomNavBar._indicatorWidth / 2);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                key: const Key('simu_nav_indicator'),
                duration: AppMotion.durationNormal,
                curve: AppMotion.curveStandard,
                left: indicatorLeft,
                bottom: 0,
                width: SimuBottomNavBar._indicatorWidth,
                height: SimuBottomNavBar._indicatorHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: SimuBottomNavBar._activeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: FontAwesomeIcons.solidHouse,
                      label: SimuNavDestination.home.label,
                      isSelected: current == SimuNavDestination.home,
                      onTap: () =>
                          onDestinationSelected(SimuNavDestination.home),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: FontAwesomeIcons.solidMap,
                      label: SimuNavDestination.journey.label,
                      isSelected: current == SimuNavDestination.journey,
                      onTap: () =>
                          onDestinationSelected(SimuNavDestination.journey),
                    ),
                  ),
                  const SizedBox(width: SimuBottomNavBar._centerGap),
                  Expanded(
                    child: _NavItem(
                      icon: FontAwesomeIcons.solidCommentDots,
                      label: SimuNavDestination.practice.label,
                      isSelected: current == SimuNavDestination.practice,
                      onTap: () =>
                          onDestinationSelected(SimuNavDestination.practice),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: FontAwesomeIcons.solidUser,
                      label: SimuNavDestination.profile.label,
                      isSelected: current == SimuNavDestination.profile,
                      onTap: () =>
                          onDestinationSelected(SimuNavDestination.profile),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final FaIconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: TweenAnimationBuilder<double>(
              duration: AppMotion.durationNormal,
              curve: AppMotion.curveStandard,
              tween: Tween(end: isSelected ? 1 : 0),
              builder: (context, t, _) {
                final color = Color.lerp(
                  SimuBottomNavBar._inactiveColor,
                  SimuBottomNavBar._activeColor,
                  t,
                )!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1 + (t * 0.08),
                      child: FaIcon(icon, size: 20, color: color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.lerp(
                          FontWeight.w600,
                          FontWeight.w700,
                          t,
                        ),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CenterPawButton extends StatefulWidget {
  const _CenterPawButton({this.onTap});

  final VoidCallback? onTap;

  @override
  State<_CenterPawButton> createState() => _CenterPawButtonState();
}

class _CenterPawButtonState extends State<_CenterPawButton> {
  bool _isPressed = false;

  static const double _size = SimuBottomNavBar._pawSize;
  static const double _depthHeight = 4;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Simu quick action',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: _size,
          height: _size + _depthHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: _depthHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4C2FC0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: AppMotion.durationFast,
                curve: AppMotion.curveDecelerate,
                top: _isPressed ? _depthHeight : 0,
                left: 0,
                right: 0,
                bottom: _isPressed ? 0 : _depthHeight,
                child: Image.asset(
                  SimuBottomNavBar.centerPawAsset,
                  width: _size,
                  height: _size,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: _size,
                    height: _size,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7551FF),
                      shape: BoxShape.circle,
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.paw,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
