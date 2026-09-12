import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/transitions/curtain_transition_controller.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_spark_splay.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_spark_column_divider.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_tactile_surface.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_xp_badge.dart';

/// Screen — Meet Ace introduction after onboarding selections.
class MeetAcePage extends ConsumerWidget {
  const MeetAcePage({super.key});

  static const String backgroundAsset =
      'assets/illustrations/onboarding/meet_ace/meet_ace_background.png';
  static const String starIconAsset = 'assets/icons/star_icon.png';
  static const String practiceIconAsset =
      'assets/illustrations/onboarding/meet_ace/icons/practice_icon.png';
  static const String levelUpIconAsset =
      'assets/illustrations/onboarding/meet_ace/icons/level_up_icon.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalXp = ref.watch(onboardingControllerProvider).totalOnboardingXp;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: const Color(0xFFF9F6EE)),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OnboardingXpBadge(totalXp: totalXp),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: _MeetAceHeadline(),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _MeetAceFeaturesPanel(),
                        SizedBox(height: 12),
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
                      text: "Let's go!",
                      leftWidget: const SizedBox(width: 40),
                      onPressed: () async {
                        if (ref
                            .read(curtainTransitionControllerProvider)
                            .isActive) {
                          return;
                        }
                        await ref
                            .read(curtainTransitionControllerProvider.notifier)
                            .start(
                              prepare: () async => true,
                              navigate: () async {
                                if (context.mounted) {
                                  context.go(RouteNames.onboardingJourney);
                                }
                              },
                              reduceMotion: false,
                            );
                      },
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

class _MeetAceHeadline extends StatelessWidget {
  const _MeetAceHeadline();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.displayLarge.copyWith(
              fontSize: 30,
              height: 1.12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF262554),
            ),
            children: const [
              TextSpan(text: "Hey! I'm "),
              TextSpan(
                text: 'Ace',
                style: TextStyle(
                  color: Color(0xFF7551FF),
                  fontWeight: FontWeight.w800,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(left: 6, bottom: 2),
                  child: OnboardingSparkSplay(isLeft: false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFF262554),
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
            children: const [
              TextSpan(text: 'Your personal '),
              TextSpan(
                text: 'practice buddy',
                style: TextStyle(
                  color: Color(0xFF7551FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: '.\n'),
              TextSpan(text: "I'm here to help you build real\n"),
              TextSpan(text: 'skills and become unstoppable. 💜'),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeetAceFeaturesPanel extends StatelessWidget {
  const _MeetAceFeaturesPanel();

  @override
  Widget build(BuildContext context) {
    return OnboardingTactileSurface(
      showOuterShadow: false,
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "✦  Here's what we'll do together  ✦",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTypography.heading3.copyWith(
              color: const Color(0xFF7551FF),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _MeetAceFeatureColumn(
                    iconAsset: MeetAcePage.practiceIconAsset,
                    title: 'Practice',
                    subtitle: 'Real-world scenarios that build your skills.',
                  ),
                ),
                _MeetAceFeatureDivider(),
                Expanded(
                  child: _MeetAceFeatureColumn(
                    iconAsset: MeetAcePage.starIconAsset,
                    title: 'Improve',
                    subtitle: 'Get feedback that helps you grow.',
                  ),
                ),
                _MeetAceFeatureDivider(),
                Expanded(
                  child: _MeetAceFeatureColumn(
                    iconAsset: MeetAcePage.levelUpIconAsset,
                    title: 'Level Up',
                    subtitle:
                        'Earn XP, unlock skills, become better every day.',
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

class _MeetAceFeatureColumn extends StatelessWidget {
  const _MeetAceFeatureColumn({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  final String iconAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          iconAsset,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const SizedBox(width: 40, height: 40),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.titleSmall.copyWith(
            color: const Color(0xFF7551FF),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: AppTypography.caption.copyWith(
            color: const Color(0xFF5A627D),
            fontSize: 10,
            height: 1.25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Soft dotted spark divider between Meet Ace feature columns.
class _MeetAceFeatureDivider extends StatelessWidget {
  const _MeetAceFeatureDivider();

  @override
  Widget build(BuildContext context) {
    return const OnboardingSparkColumnDivider();
  }
}
