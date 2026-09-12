import 'package:flutter/material.dart';

/// Draws the 3 diagonal splayed hand-drawn spark dashes used in onboarding headers.
class OnboardingSparkSplay extends StatelessWidget {
  const OnboardingSparkSplay({super.key, required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(14, 12),
      painter: _SparkSplayPainter(isLeft: isLeft),
    );
  }
}

class _SparkSplayPainter extends CustomPainter {
  const _SparkSplayPainter({required this.isLeft});

  final bool isLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFE879F9)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = const Color(0xFF7551FF)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final paint3 = Paint()
      ..color = const Color(0xFFC084FC)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.save();
    if (!isLeft) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    canvas.drawLine(const Offset(11, 4), const Offset(2, 1), paint1);
    canvas.drawLine(const Offset(13, 6), const Offset(1, 6), paint2);
    canvas.drawLine(const Offset(11, 8), const Offset(2, 11), paint3);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
