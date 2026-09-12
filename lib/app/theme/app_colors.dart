import 'package:flutter/material.dart';

/// Simu Light Theme Color Palette & Design Tokens.
///
/// Simu strictly uses a bright, playful, premium, tactile, game-like light visual system.
class AppColors {
  const AppColors._();

  // Primary Brand Colors (Vibrant Purple / Indigo)
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8C7FF7);
  static const Color primaryDark = Color(0xFF5544CE);
  static const Color primaryContainer = Color(0xFFEDE9FE);
  static const Color onPrimaryContainer = Color(0xFF372992);

  // Background & Surfaces (Warm White, Cream, Soft Pastel)
  static const Color background = Color(0xFFFBFBFE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF4F1FA);
  static const Color surfaceCream = Color(0xFFFFF9EE);
  static const Color surfaceHighlight = Color(0xFFF0EDFF);

  // Neutral Text Colors
  static const Color textPrimary = Color(0xFF1E1B4B);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accent Colors (Game-like accents for achievements, XP, states)
  static const Color accentGreen = Color(0xFF10B981); // Mint / Success
  static const Color accentGreenLight = Color(0xFFD1FAE5);
  static const Color accentYellow = Color(0xFFF59E0B); // Amber / XP / Gold
  static const Color accentYellowLight = Color(0xFFFEF3C7);
  static const Color accentCoral = Color(0xFFF43F5E); // Coral / Streak / Energy
  static const Color accentCoralLight = Color(0xFFFFE4E6);
  static const Color accentSky = Color(0xFF38BDF8); // Sky Blue / Information
  static const Color accentSkyLight = Color(0xFFE0F2FE);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E2F2);
  static const Color borderLight = Color(0xFFF0EEF8);
  static const Color borderActive = Color(0xFF6C5CE7);

  // Tactile Depth Colors (for 3D bottom button borders & card depths)
  static const Color depthPrimary = Color(0xFF4C3EC4);
  static const Color depthSecondary = Color(0xFFD3CEE8);
  static const Color depthYellow = Color(0xFFD97706);
  static const Color depthGreen = Color(0xFF059669);

  // Shadows
  static const Color shadowLight = Color(0x0F1E1B4B);
  static const Color shadowMedium = Color(0x1A1E1B4B);
  static const Color shadowStrong = Color(0x261E1B4B);
}
