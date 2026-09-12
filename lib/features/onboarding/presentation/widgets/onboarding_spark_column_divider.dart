import 'package:flutter/material.dart';

/// Dotted spark column divider used in Meet Ace and journey summary cards.
class OnboardingSparkColumnDivider extends StatelessWidget {
  const OnboardingSparkColumnDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: SizedBox(
        width: 10,
        child: CustomPaint(painter: _SparkDividerPainter()),
      ),
    );
  }
}

class _SparkDividerPainter extends CustomPainter {
  const _SparkDividerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF7551FF).withValues(alpha: 0.28)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const dashHeight = 3.2;
    const gap = 3.6;
    final centerX = size.width / 2;
    var y = 2.0;
    final midY = size.height / 2;

    while (y < midY - 8) {
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, y + dashHeight),
        linePaint,
      );
      y += dashHeight + gap;
    }

    final sparkPaint = Paint()
      ..color = const Color(0xFF7551FF).withValues(alpha: 0.55)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(centerX, midY - 3.5),
      Offset(centerX, midY + 3.5),
      sparkPaint,
    );
    canvas.drawLine(
      Offset(centerX - 3.5, midY),
      Offset(centerX + 3.5, midY),
      sparkPaint,
    );

    y = midY + 8;
    while (y < size.height - 2) {
      final end = (y + dashHeight).clamp(0, size.height - 2);
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, end.toDouble()),
        linePaint,
      );
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
