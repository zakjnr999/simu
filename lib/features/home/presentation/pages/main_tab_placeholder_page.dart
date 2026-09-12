import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Lightweight placeholder for non-home main tabs while their screens are built.
class MainTabPlaceholderPage extends StatelessWidget {
  const MainTabPlaceholderPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: AppTypography.heading2.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
