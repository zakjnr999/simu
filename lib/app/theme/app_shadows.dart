import 'package:flutter/widgets.dart';
import 'package:simu/app/theme/app_colors.dart';

/// Simu shadow & depth design tokens.
class AppShadows {
  const AppShadows._();

  // Subtle ambient card shadow for light theme
  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  // Elevated floating element shadow
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // Selected card / glowing highlight
  static const List<BoxShadow> glowPrimary = [
    BoxShadow(
      color: Color(0x336C5CE7),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
