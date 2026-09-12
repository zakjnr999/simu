import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/journey/presentation/providers/your_journey_provider.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_spark_column_divider.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';

/// Four-column summary of onboarding selections.
class JourneySummaryCard extends StatelessWidget {
  const JourneySummaryCard({
    super.key,
    required this.items,
  });

  final List<JourneySummaryItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: OnboardingTactileSurface(
        showOuterShadow: false,
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "✦  Here's Your Summary  ✦",
              textAlign: TextAlign.center,
              style: AppTypography.heading3.copyWith(
                color: const Color(0xFF7551FF),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const OnboardingSparkColumnDivider(),
                    Expanded(child: _SummaryItem(item: items[i])),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.item});

  final JourneySummaryItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (item.iconAssetPath != null)
          Image.asset(
            item.iconAssetPath!,
            width: 34,
            height: 34,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox(width: 34, height: 34),
          )
        else
          const SizedBox(width: 34, height: 34),
        const SizedBox(height: 8),
        Text(
          item.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppTypography.caption.copyWith(
            color: const Color(0xFF262554),
            fontSize: 9,
            height: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: AppTypography.caption.copyWith(
            color: const Color(0xFF5A6AE8),
            fontSize: 9,
            height: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
