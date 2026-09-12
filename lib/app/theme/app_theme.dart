import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Centralized Simu light theme definition.
class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.bodyFontFamily,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.accentSky,
        onSecondary: AppColors.textPrimary,
        error: AppColors.accentCoral,
        onError: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceMuted,
        outline: AppColors.border,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.heading1,
        displaySmall: AppTypography.heading2,
        headlineLarge: AppTypography.heading2,
        headlineMedium: AppTypography.heading3,
        headlineSmall: AppTypography.titleLarge,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.buttonLarge,
        labelMedium: AppTypography.buttonMedium,
        labelSmall: AppTypography.badge,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.heading3,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.roundedLg,
          side: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.surface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedXl),
        titleTextStyle: AppTypography.heading2,
        contentTextStyle: AppTypography.bodyMedium,
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: AppTypography.captionMedium
            .copyWith(color: AppColors.textOnPrimary),
        decoration: const BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: AppRadii.roundedSm,
        ),
      ),
    );
  }
}
