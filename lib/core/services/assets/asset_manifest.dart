/// Curated asset paths for startup preloading.
///
/// Keep lists in sync when adding bundles under [pubspec.yaml] `assets:`.
/// Group by feature so we can preload critical paths on splash and defer
/// heavier bundles later if needed.
abstract final class SimuAssetManifest {
  /// Shown immediately on splash — always preload first.
  static const List<String> splash = [
    'assets/illustrations/splash/splash_background.png',
    'assets/illustrations/splash/paw_icon.png',
    'assets/icons/paw_icon.png',
    'assets/icons/star_icon.png',
  ];

  /// Welcome flow, curtain transition, and Meet Ace.
  static const List<String> onboardingCore = [
    'assets/illustrations/onboarding/onboarding_world.png',
    'assets/illustrations/onboarding/ace_onboarding.png',
    'assets/illustrations/onboarding/treasure_chest.png',
    'assets/illustrations/onboarding/flag_start.png',
    'assets/illustrations/onboarding/selected_card_top_badge.png',
    'assets/illustrations/onboarding/curtains/curtain_left.png',
    'assets/illustrations/onboarding/curtains/curtain_right.png',
    'assets/illustrations/onboarding/meet_ace/meet_ace_background.png',
    'assets/illustrations/onboarding/meet_ace/ace_head.png',
    'assets/illustrations/onboarding/meet_ace/icons/practice_icon.png',
    'assets/illustrations/onboarding/meet_ace/icons/level_up_icon.png',
    'assets/illustrations/onboarding/your_journey/your_journey_background.jpg',
    'assets/illustrations/onboarding/journey/milestones/milestone_01_flag.png',
    'assets/illustrations/onboarding/journey/milestones/milestone_02_speech.png',
    'assets/illustrations/onboarding/journey/milestones/milestone_03_shield.png',
    'assets/illustrations/onboarding/journey/milestones/milestone_04_trophy.png',
  ];

  static const List<String> onboardingIcons = [
    'assets/illustrations/onboarding/icons/communication_icon.png',
    'assets/illustrations/onboarding/icons/technical_icon.png',
    'assets/illustrations/onboarding/icons/interviews_icon.png',
    'assets/illustrations/onboarding/icons/negotiation_icon.png',
    'assets/illustrations/onboarding/icons/goal_boost_confidence.png',
    'assets/illustrations/onboarding/icons/goal_communication.png',
    'assets/illustrations/onboarding/icons/goal_dream_job.png',
    'assets/illustrations/onboarding/icons/goal_grow_career.png',
    'assets/illustrations/onboarding/icons/goal_be_best.png',
    'assets/illustrations/onboarding/icons/mastery_confidence.png',
    'assets/illustrations/onboarding/icons/mastery_interviews.png',
    'assets/illustrations/onboarding/icons/mastery_negotiation.png',
    'assets/illustrations/onboarding/icons/mastery_technical.png',
    'assets/illustrations/onboarding/icons/experience_starting.png',
    'assets/illustrations/onboarding/icons/experience_finding.png',
    'assets/illustrations/onboarding/icons/experience_confident.png',
    'assets/illustrations/onboarding/icons/experience_strong.png',
    'assets/illustrations/onboarding/icons/commitment_5_10.png',
    'assets/illustrations/onboarding/icons/commitment_10_20.png',
    'assets/illustrations/onboarding/icons/commitment_20_30.png',
    'assets/illustrations/onboarding/icons/commitment_30_45.png',
    'assets/illustrations/onboarding/icons/commitment_45_plus.png',
  ];

  static const List<String> onboardingAvatars = [
    'assets/illustrations/onboarding/avatars/learner_1.png',
    'assets/illustrations/onboarding/avatars/learner_2.png',
    'assets/illustrations/onboarding/avatars/learner_3.png',
  ];

  /// Everything needed before leaving splash for a first-time user.
  static List<String> get splashPreload => [
        ...splash,
        ...onboardingCore,
        ...onboardingIcons,
        ...onboardingAvatars,
      ];

  /// App font families declared in [pubspec.yaml].
  static const List<String> fontFamilies = [
    'Fredoka',
    'Nunito Sans',
  ];
}
