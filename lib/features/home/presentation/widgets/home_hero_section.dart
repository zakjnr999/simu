import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Home greeting — positioned and styled like Meet Ace headline.
class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.displayName,
  });

  final String displayName;

  /// Keeps copy on the left so it does not overlap Ace in the hero art.
  static const double _textWidthFactor = 0.5;

  @override
  Widget build(BuildContext context) {
    final maxTextWidth = MediaQuery.sizeOf(context).width * _textWidthFactor;

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: maxTextWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 30,
                  height: 1.12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF262554),
                ),
                children: [
                  const TextSpan(text: 'Hey, '),
                  TextSpan(
                    text: displayName,
                    style: const TextStyle(
                      color: Color(0xFF7551FF),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(text: '! 👋'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xFF262554),
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
                children: const [
                  TextSpan(text: "Let's keep building "),
                  TextSpan(
                    text: 'your skills',
                    style: TextStyle(
                      color: Color(0xFF7551FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' \nand become unstoppable.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
