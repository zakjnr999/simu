import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_spark_splay.dart';

/// Hero greeting over the journey background — aligned like Meet Ace headline.
class JourneyHeroSection extends StatelessWidget {
  const JourneyHeroSection({
    super.key,
    required this.displayName,
  });

  final String displayName;

  /// Keeps copy on the left so it does not overlap Ace in the hero art.
  static const double _textWidthFactor = 0.56;

  @override
  Widget build(BuildContext context) {
    final maxTextWidth = MediaQuery.sizeOf(context).width * _textWidthFactor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Align(
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
                    const TextSpan(text: 'Your Journey\nis Ready,\n'),
                    TextSpan(
                      text: '$displayName!',
                      style: const TextStyle(
                        color: Color(0xFF7551FF),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(left: 6, bottom: 2),
                        child: OnboardingSparkSplay(isLeft: false),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
