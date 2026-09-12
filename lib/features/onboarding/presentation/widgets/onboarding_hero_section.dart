import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_shadows.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Hero Section for Onboarding featuring headline, custom painted flourish stroke,
/// and the interactive speech bubble positioned above the background mascot.
///
/// Refactored to support dynamic animated swaps between Steps 1 to 5.
class OnboardingHeroSection extends StatelessWidget {
  const OnboardingHeroSection({
    super.key,
    this.currentStep = 1,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width <= 375;

    return Padding(
      padding: EdgeInsets.only(
        left: isNarrow ? 14 : 20,
        right: isNarrow ? 12 : 18,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Left side: Headline & Description (AnimatedSwitcher)
            Expanded(
              flex: isNarrow ? 5 : 6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                layoutBuilder:
                    (Widget? currentChild, List<Widget> previousChildren) {
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildHeadline(
                  key: ValueKey('headline_step_$currentStep'),
                  isNarrow: isNarrow,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Right side: Speech bubble floating above background Ace Mascot
            Expanded(
              flex: isNarrow ? 5 : 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      key: ValueKey('bubble_and_pointer_step_$currentStep'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isNarrow ? 8 : 12,
                            vertical: isNarrow ? 6 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppShadows.card,
                          ),
                          child: _buildBubbleContent(isNarrow: isNarrow),
                        ),
                        CustomPaint(
                          size: const Size(18, 9),
                          painter: _SpeechBubblePointerPainter(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline({required Key key, bool isNarrow = false}) {
    final double headlineSize = isNarrow ? 24 : 30;

    if (currentStep == 1) {
      return Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: AppTypography.displayLarge.copyWith(
                fontSize: headlineSize,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF262554),
              ),
              children: const [
                TextSpan(text: 'Practice\ntoday,\n'),
                TextSpan(
                  text: 'level up\n',
                  style: TextStyle(
                    color: Color(0xFF7551FF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: 'tomorrow.'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const CustomPaint(
            size: Size(68, 8),
            painter: _TitleFlourishPainter(),
          ),
        ],
      );
    }

    // Step 2-5 Headline RichText Copy with highlighted last words
    List<TextSpan> titleSpans = [];

    switch (currentStep) {
      case 2:
        titleSpans = const [
          TextSpan(text: 'What do\nyou want to\n'),
          TextSpan(
            text: 'master?',
            style: TextStyle(
              color: Color(0xFF7551FF),
              fontWeight: FontWeight.w800,
            ),
          ),
        ];

        break;
      case 3:
        titleSpans = const [
          TextSpan(text: 'Where are\nyou on\nyour '),
          TextSpan(
            text: 'journey?',
            style: TextStyle(
              color: Color(0xFF7551FF),
              fontWeight: FontWeight.w800,
            ),
          ),
        ];

        break;
      case 4:
        titleSpans = const [
          TextSpan(text: 'What’s your\nmain '),
          TextSpan(
            text: 'goal?',
            style: TextStyle(
              color: Color(0xFF7551FF),
              fontWeight: FontWeight.w800,
            ),
          ),
        ];

        break;
      case 5:
        titleSpans = const [
          TextSpan(text: 'How much time\ncan you commit\n'),
          TextSpan(
            text: 'daily?',
            style: TextStyle(
              color: Color(0xFF7551FF),
              fontWeight: FontWeight.w800,
            ),
          ),
        ];

        break;
      default:
        titleSpans = const [
          TextSpan(text: 'Welcome\nto '),
          TextSpan(
            text: 'Simu!',
            style: TextStyle(
              color: Color(0xFF7551FF),
              fontWeight: FontWeight.w800,
            ),
          ),
        ];
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: AppTypography.displayLarge.copyWith(
              fontSize: headlineSize,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF262554),
            ),
            children: titleSpans,
          ),
        ),
        const SizedBox(height: 4),
        const CustomPaint(
          size: Size(68, 8),
          painter: _TitleFlourishPainter(),
        ),
      ],
    );
  }

  Widget _buildBubbleContent({bool isNarrow = false}) {
    if (currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Hi! I’m Ace 👋',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    color: const Color(0xFF7551FF),
                    fontSize: isNarrow ? 11 : 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'I’ll be with you on your\njourney to become\nyour best self!',
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF2E2B54),
              fontSize: isNarrow ? 10 : 11,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    // Step 2-5 bubble text copy
    String text1 = '';
    String text2Highlighted = '';
    String text3 = '';

    switch (currentStep) {
      case 2:
        text1 = 'Each goal unlocks a\n';
        text2Highlighted = 'stronger, better you!\n';
        text3 = 'Let’s go!';
        break;
      case 3:
        text1 = 'There’s no right or\n';
        text2Highlighted = 'wrong here! Just pick\n';
        text3 = 'what feels like you.';
        break;
      case 4:
        text1 = 'Big goals, ';
        text2Highlighted = 'real growth!\n';
        text3 = 'Let’s make it happen.';
        break;
      case 5:
        text1 = 'Small steps everyday ';
        text2Highlighted = 'lead\nto big wins!\n';
        text3 = 'consistency is key!';
        break;
      default:
        text1 = 'Let\'s practice ';
        text2Highlighted = 'and grow!\n';
        text3 = 'Let\'s go!';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF2E2B54),
              fontSize: isNarrow ? 10 : 11,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(text: text1),
              TextSpan(
                text: text2Highlighted,
                style: const TextStyle(
                  color: Color(0xFF7551FF),
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(text: text3),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter rendering the dynamic two-tone hand-drawn marker flourish stroke.
class _TitleFlourishPainter extends CustomPainter {
  const _TitleFlourishPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Extended thin lighter trailing tail on the right
    final tailPaint = Paint()
      ..color = const Color(0xFF7551FF).withValues(alpha: 0.38)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final tailPath = Path()
      ..moveTo(size.width * 0.36, size.height * 0.44)
      ..quadraticBezierTo(
        size.width * 0.68,
        size.height * 0.40,
        size.width * 0.95,
        size.height * 0.48,
      );

    canvas.drawPath(tailPath, tailPaint);

    // 2. Thick solid vibrant purple stroke on the left
    final mainPaint = Paint()
      ..color = const Color(0xFF7551FF)
      ..strokeWidth = 5.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final mainPath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.40,
        size.width * 0.54,
        size.height * 0.46,
      );

    canvas.drawPath(mainPath, mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpeechBubblePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      // Left slope down towards the rounded tip
      ..lineTo(size.width * 0.38, size.height * 0.78)
      // Rounded tip curve
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width * 0.62,
        size.height * 0.78,
      )
      // Right slope back up to the right top corner
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
