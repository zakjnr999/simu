/// Journey milestone island artwork (PNG, used as-is).
abstract final class JourneyMilestoneAssets {
  static const String milestone01Flag =
      'assets/illustrations/onboarding/journey/milestones/milestone_01_flag.png';
  static const String milestone02Speech =
      'assets/illustrations/onboarding/journey/milestones/milestone_02_speech.png';
  static const String milestone03Shield =
      'assets/illustrations/onboarding/journey/milestones/milestone_03_shield.png';
  static const String milestone04Trophy =
      'assets/illustrations/onboarding/journey/milestones/milestone_04_trophy.png';

  static const List<String> previewOrder = [
    milestone01Flag,
    milestone02Speech,
    milestone03Shield,
    milestone04Trophy,
  ];

  /// 1-based preview position on the journey path.
  static String forPreviewPosition(int position) {
    return previewOrder[(position - 1).clamp(0, previewOrder.length - 1)];
  }
}
