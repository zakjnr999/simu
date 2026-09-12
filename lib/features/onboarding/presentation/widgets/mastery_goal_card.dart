import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_motion.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Reusable tactile choice option card matching the visual style of PracticeCategoryCard.
class OnboardingChoiceCard extends StatelessWidget {
  const OnboardingChoiceCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.xpBonus,
    required this.iconEmoji,
    required this.isSelected,
    required this.onTap,
    this.iconAssetPath,
  });

  final String id;
  final String title;
  final String description;
  final int xpBonus;
  final String iconEmoji;
  final bool isSelected;
  final VoidCallback onTap;
  final String? iconAssetPath;

  Color _titleColorForId(String id) {
    if (id.contains('dream') || id.contains('start') || id == '5_10_min') {
      return const Color(0xFF38A169); // Green
    } else if (id.contains('confidence') || id.contains('feet') || id == '10_20_min') {
      return const Color(0xFF7551FF); // Purple/Violet
    } else if (id.contains('think') || id.contains('grow') || id == '20_30_min') {
      return const Color(0xFFE05A38); // Orange/Amber
    } else if (id.contains('tough') || id.contains('best') || id == '30_45_min') {
      return const Color(0xFFE54A4A); // Red
    } else {
      return const Color(0xFF3B82F6); // Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = _titleColorForId(id);

    return Semantics(
      selected: isSelected,
      button: true,
      label: '$title, $description, plus $xpBonus XP',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: AppMotion.durationNormal,
              curve: AppMotion.curveStandard,
              width: 96,
              height: 154,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF6F0FF)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8C64FF)
                      : const Color(0xFFEFE8DD),
                  width: isSelected ? 2.0 : 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Center Graphic/Icon
                  if (iconAssetPath != null)
                    Image.asset(
                      iconAssetPath!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Text(
                        iconEmoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    )
                  else
                    Text(
                      iconEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  const SizedBox(height: 6),

                  // Title Text
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.titleSmall.copyWith(
                        color: titleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle Description
                  Expanded(
                    child: Center(
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFF5A627D),
                          fontSize: 10.5,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Bottom XP Badge
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: Color(0xFFFEB504),
                          size: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '+$xpBonus XP',
                          style: AppTypography.caption.copyWith(
                            color: const Color(0xFF5A627D),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Top-left selected badge
            if (isSelected)
              Positioned(
                top: -6,
                left: 6,
                child: Image.asset(
                  'assets/illustrations/onboarding/selected_card_top_badge.png',
                  width: 24,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

            // Bottom-center Checkmark Badge on selected state
            if (isSelected)
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7551FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x307551FF),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      color: Colors.white,
                      size: 13,
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
