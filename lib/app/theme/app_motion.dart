import 'package:flutter/animation.dart';

/// Simu motion and animation tokens.
class AppMotion {
  const AppMotion._();

  // Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationRelaxed = Duration(milliseconds: 600);

  // Curtain transition (onboarding → Meet Ace)
  static const Duration curtainClose = Duration(milliseconds: 600);
  static const Duration curtainHold = Duration(milliseconds: 400);
  static const Duration curtainOpen = Duration(milliseconds: 600);
  static const Duration curtainCloseReduced = Duration(milliseconds: 120);
  static const Duration curtainHoldReduced = Duration(milliseconds: 80);
  static const Duration curtainOpenReduced = Duration(milliseconds: 120);

  // Curves
  static const Curve curveStandard = Curves.easeInOutCubic;
  static const Curve curtainCurve = Curves.easeInOutCubic;
  static const Curve curveBouncy = Curves.easeOutBack;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveDecelerate = Curves.easeOutQuad;
  static const Curve curveAccelerate = Curves.easeInQuad;
}
