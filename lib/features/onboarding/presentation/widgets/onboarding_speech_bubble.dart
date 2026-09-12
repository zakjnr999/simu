import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_shadows.dart';

/// Tail placement for onboarding speech bubbles.
enum OnboardingSpeechBubbleTail {
  /// Points downward from the bottom edge (hero / Ace mouth).
  bottomCenter,

  /// Points down-left from the bottom-left corner (Meet Ace upper bubble).
  bottomLeft,

  /// Points left from the left edge (avatar companion bubble).
  leftCenter,
}

/// Speech bubble used across onboarding, with configurable tail direction.
class OnboardingSpeechBubble extends StatelessWidget {
  const OnboardingSpeechBubble({
    super.key,
    required this.child,
    this.tail = OnboardingSpeechBubbleTail.bottomCenter,
    this.maxWidth,
    this.showShadow = true,
  });

  final Widget child;
  final OnboardingSpeechBubbleTail tail;
  final double? maxWidth;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: showShadow
            ? null
            : Border.all(
                color: const Color(0xFFE0D6C8),
                width: 1.5,
              ),
        boxShadow: showShadow ? AppShadows.card : null,
      ),
      child: child,
    );

    final tailOutlineColor =
        showShadow ? null : const Color(0xFFE0D6C8);

    return switch (tail) {
      OnboardingSpeechBubbleTail.bottomCenter => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bubble,
            CustomPaint(
              size: const Size(18, 9),
              painter: _BottomCenterTailPainter(
                outlineColor: tailOutlineColor,
              ),
            ),
          ],
        ),
      OnboardingSpeechBubbleTail.bottomLeft => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bubble,
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: CustomPaint(
                size: const Size(16, 10),
                painter: _BottomLeftTailPainter(
                  outlineColor: tailOutlineColor,
                ),
              ),
            ),
          ],
        ),
      OnboardingSpeechBubbleTail.leftCenter => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(10, 16),
              painter: _LeftCenterTailPainter(
                outlineColor: tailOutlineColor,
              ),
            ),
            Expanded(child: bubble),
          ],
        ),
    };
  }
}

class _BottomCenterTailPainter extends CustomPainter {
  const _BottomCenterTailPainter({this.outlineColor});

  final Color? outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.38, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width * 0.62,
        size.height * 0.78,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    if (outlineColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = outlineColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BottomCenterTailPainter oldDelegate) =>
      oldDelegate.outlineColor != outlineColor;
}

class _BottomLeftTailPainter extends CustomPainter {
  const _BottomLeftTailPainter({this.outlineColor});

  final Color? outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.15, 0)
      ..lineTo(0, size.height)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.55,
        size.width * 0.42,
        size.height * 0.35,
      )
      ..lineTo(size.width * 0.55, 0)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    if (outlineColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = outlineColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BottomLeftTailPainter oldDelegate) =>
      oldDelegate.outlineColor != outlineColor;
}

class _LeftCenterTailPainter extends CustomPainter {
  const _LeftCenterTailPainter({this.outlineColor});

  final Color? outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width, size.height * 0.18)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.5,
        size.width * 0.55,
        size.height * 0.82,
      )
      ..lineTo(size.width, size.height * 0.62)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    if (outlineColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = outlineColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LeftCenterTailPainter oldDelegate) =>
      oldDelegate.outlineColor != outlineColor;
}
