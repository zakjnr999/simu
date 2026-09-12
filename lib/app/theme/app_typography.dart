import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';

/// Centralized Typography tokens for Simu.
///
/// Strictly uses:
/// - **Fredoka**: Primary display & game brand font for headings, buttons, badges, XP, and rewards.
/// - **Nunito Sans**: Primary body & information font for readable content, descriptions, and metadata.
class AppTypography {
  const AppTypography._();

  // Approved Font Families
  static const String displayFontFamily = 'Fredoka';
  static const String bodyFontFamily = 'Nunito Sans';

  // ---------------------------------------------------------------------------
  // Fredoka — Display & Headings (Hero, Titles, Game Moments)
  // ---------------------------------------------------------------------------

  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.4,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: -0.3,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: -0.2,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: -0.1,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ---------------------------------------------------------------------------
  // Fredoka — Interactive Actions, Badges & Rewards
  // ---------------------------------------------------------------------------

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0.2,
    height: 1.2,
    color: AppColors.textOnPrimary,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0.1,
    height: 1.2,
    color: AppColors.textOnPrimary,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.2,
    color: AppColors.textOnPrimary,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0.4,
    height: 1.2,
    color: AppColors.primary,
  );

  static const TextStyle xp = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.accentYellow,
  );

  static const TextStyle reward = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.2,
    height: 1.2,
    color: AppColors.accentYellow,
  );

  // ---------------------------------------------------------------------------
  // Nunito Sans — Body, Descriptions, Scenario Content & Metadata
  // ---------------------------------------------------------------------------

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyLargeSemiBold = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMediumSemiBold = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
    color: AppColors.textTertiary,
  );

  static const TextStyle bodySmallSemiBold = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400, // Regular
    height: 1.3,
    color: AppColors.textTertiary,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    color: AppColors.textSecondary,
  );
}
