import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';

/// Motivational banner below the journey path preview.
class JourneyMotivationBanner extends StatelessWidget {
  const JourneyMotivationBanner({super.key});

  static const String starIconAsset = 'assets/icons/star_icon.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFF8E8),
              Color(0xFFFFFDF6),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.55),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              starIconAsset,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Text('⭐', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Stay consistent, grow your skills,\nand achieve your goals. 💜',
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF262554),
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF8EC5FF),
                    Color(0xFF5A9FE8),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF7551FF).withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.flag_rounded,
                size: 18,
                color: Color(0xFF7551FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
