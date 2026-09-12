import 'package:flutter/material.dart';

/// Pill-shaped bottom bar with a paw-sized notch, rounded shoulders, and
/// transparent bays beside the paw.
class NavBarNotchShape extends ShapeBorder {
  const NavBarNotchShape({
    this.cornerRadius = 24,
    this.notchRadius = 34,
    this.guestCenterFromTop = 24,
    this.shoulderFillet = 6,
    this.side = BorderSide.none,
  });

  final double cornerRadius;
  final double notchRadius;
  final double guestCenterFromTop;
  final double shoulderFillet;
  final BorderSide side;

  static Path buildPath(
    Rect rect, {
    required double cornerRadius,
    required double notchRadius,
    required double guestCenterFromTop,
    required double shoulderFillet,
  }) {
    final guest = Rect.fromCenter(
      center: Offset(rect.center.dx, rect.top + guestCenterFromTop),
      width: notchRadius * 2,
      height: notchRadius * 2,
    );
    final notch = const CircularNotchedRectangle().getOuterPath(rect, guest);
    final pill = Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect,
        Radius.circular(cornerRadius.clamp(0, rect.height / 2).toDouble()),
      ));

    return Path.combine(PathOperation.intersect, pill, notch);
  }


  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(
      rect.deflate(side.width / 2),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return buildPath(
      rect,
      cornerRadius: cornerRadius,
      notchRadius: notchRadius,
      guestCenterFromTop: guestCenterFromTop,
      shoulderFillet: shoulderFillet,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) {
      return;
    }

    final paint = side.toPaint()..style = PaintingStyle.stroke;
    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), paint);
  }

  @override
  ShapeBorder scale(double t) {
    return NavBarNotchShape(
      cornerRadius: cornerRadius * t,
      notchRadius: notchRadius * t,
      guestCenterFromTop: guestCenterFromTop * t,
      shoulderFillet: shoulderFillet * t,
      side: side.scale(t),
    );
  }
}
