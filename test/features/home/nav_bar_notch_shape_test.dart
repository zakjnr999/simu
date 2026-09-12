import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/home/presentation/widgets/nav_bar_notch_shape.dart';

void main() {
  test('NavBarNotchShape keeps pill sides, transparent bays, paw-sized notch', () {
    const rect = Rect.fromLTWH(0, 0, 320, 68);
    const shape = NavBarNotchShape(
      cornerRadius: 24,
      notchRadius: 34,
      guestCenterFromTop: 24,
      shoulderFillet: 6,
    );

    final path = shape.getOuterPath(rect);

    expect(
      path.contains(Offset(rect.center.dx - 24, rect.top + 8)),
      isFalse,
      reason: 'Side bays beside the paw should stay transparent',
    );
    expect(
      path.contains(Offset(rect.left + 20, rect.bottom - 10)),
      isTrue,
      reason: 'Left rounded side should remain a normal pill shape',
    );
    expect(
      path.contains(Offset(rect.center.dx, rect.bottom - 8)),
      isTrue,
      reason: 'Bar body should remain filled',
    );
  });
}
