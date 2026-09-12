import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';
import 'package:simu/features/practice/presentation/providers/practice_provider.dart';

/// Reusable card in the Practice Library displaying a practice category summary.
class PracticeCategoryCard extends StatelessWidget {
  const PracticeCategoryCard({
    super.key,
    required this.summary,
    required this.onTap,
  });

  final PracticeProgressSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final def = summary.definition;
    final isPrimary = summary.isPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: OnboardingTactileSurface(
          showOuterShadow: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Badges & Category Icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: def.accentBgColor,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: def.accentColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        def.iconEmoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (isPrimary)
                              const SimuBadge(
                                text: 'YOUR PRIMARY GOAL',
                                backgroundColor: Color(0xFFF1EFFF),
                                textColor: AppColors.primary,
                              ),
                            SimuBadge(
                              text: def.difficulty.label.toUpperCase(),
                              backgroundColor: AppColors.surfaceMuted,
                              textColor: AppColors.textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          def.title,
                          style: AppTypography.heading3.copyWith(
                            fontSize: 17,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 2. Tagline
              Text(
                def.tagline,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              // 3. Skills Practiced Chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: def.skillsPracticed.take(3).map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: AppRadii.roundedPill,
                    ),
                    child: Text(
                      skill,
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // 4. Progress bar & stats
              Row(
                children: [
                  Expanded(
                    child: SimuProgressBar(
                      progress: summary.progressRatio,
                      height: 7,
                      fillColor: def.accentColor,
                      backgroundColor: AppColors.borderLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${summary.completedCount}/${summary.totalCount} Done',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${def.estimatedMinutesPerSession} min',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
