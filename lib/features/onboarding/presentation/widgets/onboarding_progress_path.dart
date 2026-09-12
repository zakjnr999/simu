import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Progression path component showing checkpoints 1-5 with flag, lock states,
/// dotted connector, and treasure chest reward with a continuous sweep shine.
class OnboardingProgressPath extends StatelessWidget {
  const OnboardingProgressPath({
    super.key,
    this.currentStep = 1,
    this.reachedChest = false,
  });

  final int currentStep;
  final bool reachedChest;

  @override
  Widget build(BuildContext context) {
    const double circleSize = 32.0;
    const double chestSize = 40.0;
    const double flagWidth = 20.0;
    const double flagHeight = 20.0;
    // Push the path lower inside the fixed viewport without changing outer layout size.
    const double pathTopInset = 16.0;

    // Vertical top offsets creating a gentle curve matching the sand container
    final List<double> verticalOffsets = [
      73.0 + pathTopInset, // Step 1 (Start)
      63.0 + pathTopInset, // Step 2
      55.0 + pathTopInset, // Step 3
      63.0 + pathTopInset, // Step 4
      73.0 + pathTopInset, // Step 5
      67.0 + pathTopInset, // Chest (Reward)
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          const double edgePadding = 22.0;
          final double spacing = (totalWidth - (edgePadding * 2)) / 5;

          // Calculate horizontal center X coordinate for each of the 6 nodes
          final List<double> xCoords = List.generate(6, (i) => edgePadding + (i * spacing));

          // Calculate flag position based on active step or chest reached state
          final int activeIndex = reachedChest ? 5 : (currentStep - 1);
          final double flagLeft = xCoords[activeIndex] - (flagWidth / 2);
          final double flagTop = verticalOffsets[activeIndex] - flagHeight + 2;

          return SizedBox(
            height: 125,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Draw Dotted Connectors between nodes
                for (int i = 0; i < 5; i++)
                  Positioned(
                    left: xCoords[i] + 4,
                    right: totalWidth - xCoords[i + 1] + 4,
                    top: (verticalOffsets[i] + verticalOffsets[i + 1]) / 2 + (circleSize / 2) - 1.5,
                    child: const _DottedConnector(),
                  ),

                // 2. Draw 5 Step Circles
                for (int i = 0; i < 5; i++)
                  Positioned(
                    left: xCoords[i] - (circleSize / 2),
                    top: verticalOffsets[i],
                    child: _buildStepCircle(
                      stepIndex: i + 1,
                      circleSize: circleSize,
                    ),
                  ),

                // 3. Draw Treasure Chest Node (Interactive Shine on Arrival)
                Positioned(
                  left: xCoords[5] - (chestSize / 2),
                  top: verticalOffsets[5],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ShiningTreasureChest(
                        chestSize: chestSize,
                        isShining: reachedChest,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Your best\nversion!',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFF7551FF),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Animated Flag (slides from active step to the chest reward)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutBack,
                  left: flagLeft,
                  top: flagTop,
                  child: Image.asset(
                    'assets/illustrations/onboarding/flag_start.png',
                    width: flagWidth,
                    height: flagHeight,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(LucideIcons.flag, color: Colors.red, size: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepCircle({
    required int stepIndex,
    required double circleSize,
  }) {
    // Determine state of this circle, accounting for chest completion
    final bool isCompleted = stepIndex < currentStep || (reachedChest && stepIndex == 5);
    final bool isActive = stepIndex == currentStep && !reachedChest;
    final bool isLocked = stepIndex > currentStep && !reachedChest;

    Color color;
    Color depthColor;
    Widget child;

    if (isCompleted) {
      color = const Color(0xFF74CD38);
      depthColor = const Color(0xFF4FA01C);
      child = const Icon(LucideIcons.check, color: Colors.white, size: 12);
    } else if (isActive) {
      color = const Color(0xFF7551FF);
      depthColor = const Color(0xFF5027D1);
      child = Text(
        '$stepIndex',
        style: TextStyle(
          color: Colors.white,
          fontSize: circleSize * 0.44,
          fontWeight: FontWeight.w800,
          fontFamily: AppTypography.displayFontFamily,
        ),
      );
    } else {
      // Locked or pending step
      color = const Color(0xFFF0EFF5);
      depthColor = const Color(0xFFDCDAE6);
      child = Text(
        '$stepIndex',
        style: TextStyle(
          color: const Color(0xFF9E9DB8),
          fontSize: circleSize * 0.44,
          fontWeight: FontWeight.w600,
          fontFamily: AppTypography.displayFontFamily,
        ),
      );
    }

    const depthHeight = 2.5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tactile 3D Circle Button Effect
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // Depth Shadow Layer
            Container(
              margin: const EdgeInsets.only(top: depthHeight),
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: depthColor,
                shape: BoxShape.circle,
              ),
            ),
            // Surface Circle Layer
            Container(
              margin: const EdgeInsets.only(bottom: depthHeight),
              width: circleSize,
              height: circleSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLocked ? const Color(0xFFE2DDF0) : Colors.white,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: child,
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Reserve a fixed label slot so circle rows never shift between steps.
        SizedBox(
          height: 16,
          child: Align(
            alignment: Alignment.topCenter,
            child: stepIndex == 1 && currentStep == 1
                ? Text(
                    'Start!',
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFF7551FF),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  )
                : isActive
                    ? Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7551FF),
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _DottedConnector extends StatelessWidget {
  const _DottedConnector();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return Container(
          width: 4.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: const Color(0xFF7551FF).withValues(alpha: 0.72),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7551FF).withValues(alpha: 0.25),
                blurRadius: 2,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Treasure chest with a continuous subtle sweep shine.
///
/// The shine intensifies briefly when [isShining] is true (step 5 completion).
class _ShiningTreasureChest extends StatefulWidget {
  const _ShiningTreasureChest({
    required this.chestSize,
    required this.isShining,
  });

  final double chestSize;
  final bool isShining;

  @override
  State<_ShiningTreasureChest> createState() => _ShiningTreasureChestState();
}

class _ShiningTreasureChestState extends State<_ShiningTreasureChest>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chestImage = Image.asset(
      'assets/illustrations/onboarding/treasure_chest.png',
      width: widget.chestSize,
      height: widget.chestSize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        LucideIcons.gift,
        color: Color(0xFFFEB504),
        size: 26,
      ),
    );

    final peakOpacity = widget.isShining ? 0.42 : 0.28;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        final bandWidth = widget.chestSize * 0.22;
        final travel = widget.chestSize + bandWidth;
        final left = (value * 2.0 - 0.5) * travel - bandWidth;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            child!,
            SizedBox(
              width: widget.chestSize,
              height: widget.chestSize,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      left: left,
                      top: -widget.chestSize * 0.1,
                      bottom: -widget.chestSize * 0.1,
                      width: bandWidth,
                      child: Transform.rotate(
                        angle: -0.35,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: peakOpacity),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      child: chestImage,
    );
  }
}
