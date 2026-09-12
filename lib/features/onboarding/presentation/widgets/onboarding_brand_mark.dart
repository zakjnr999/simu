import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Simu wordmark: paw icon + lowercase "simu" label.
class OnboardingBrandMark extends StatelessWidget {
  const OnboardingBrandMark({super.key});

  static const String pawIconAsset = 'assets/icons/paw_icon.png';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          pawIconAsset,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Text('🐾', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 6),
        Text(
          'simu',
          style: AppTypography.titleSmall.copyWith(
            color: const Color(0xFF262453),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}
