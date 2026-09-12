import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/features/journey/presentation/providers/your_journey_provider.dart';
import 'package:simu/features/journey/presentation/widgets/journey_ace_footer.dart';
import 'package:simu/features/journey/presentation/widgets/journey_header_bar.dart';
import 'package:simu/features/journey/presentation/widgets/journey_hero_section.dart';
import 'package:simu/features/journey/presentation/widgets/journey_motivation_banner.dart';
import 'package:simu/features/journey/presentation/widgets/journey_path_section.dart';
import 'package:simu/features/journey/presentation/widgets/journey_summary_card.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';

/// Personalized journey introduction shown after Meet Ace.
class YourJourneyPage extends ConsumerWidget {
  const YourJourneyPage({super.key});

  static const String backgroundAsset =
      'assets/illustrations/onboarding/your_journey/your_journey_background.jpg';

  /// Clears Ace in the hero art before the summary card begins.
  static const double heroAceClearance = 132;

  /// Extra space between summary and journey path.
  static const double journeyTopGap = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(yourJourneyUiModelProvider);

    if (model == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFFF9F6EE)),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                JourneyHeaderBar(totalXp: model.totalXp),
                JourneyHeroSection(displayName: model.displayName),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: heroAceClearance),
                        JourneySummaryCard(items: model.summaryItems),
                        const SizedBox(height: journeyTopGap),
                        JourneyPathSection(
                          milestones: model.previewMilestones,
                        ),
                        const JourneyMotivationBanner(),
                        const JourneyAceFooter(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                    child: OnboardingPrimaryCta(
                      text: 'Enter My Journey',
                      leftWidget: const SizedBox(width: 40),
                      onPressed: () => context.go(RouteNames.home),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
